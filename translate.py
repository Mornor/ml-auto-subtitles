import shutil
import urllib.request
import boto3
import time
import json
import string
import random


class VideoFile():
    def __init__(self):
        self._audio_track = self._extract_audio()

    def _extract_audio(self):
        return 0


class Transcribe():
    def __init__(self, path_audio_input, path_transcribe_result_output, region, bucket):
        self._transcribe_job_name = self._randomize_job_name()
        self._s3_file_name = self._randomize_job_name()+'.mp3'
        self._path_audio_input = path_audio_input
        self._aws_region = region
        self._bucket_name = bucket
        self._path_transcribe_result_output = path_transcribe_result_output

    def _randomize_job_name(self):
        letters = string.ascii_lowercase
        return ''.join(random.choice(letters) for i in range(6))

    def _upload_audio_to_s3(self):
        s3 = boto3.resource('s3')
        s3.meta.client.upload_file(self._path_audio_input, self._bucket_name, self._s3_file_name)

    def _transcribe(self):
        transcribe = boto3.client('transcribe')
        job_name = self._transcribe_job_name
        job_uri = 'https://'+self._bucket_name+'.s3.' + \
            self._aws_region+'.amazonaws.com/'+self._s3_file_name
        transcribe.start_transcription_job(
            TranscriptionJobName=job_name,
            Media={'MediaFileUri': job_uri},
            MediaFormat='mp3',
            LanguageCode='en-US'
        )

        while True:
            status = transcribe.get_transcription_job(
                TranscriptionJobName=job_name)
            if status['TranscriptionJob']['TranscriptionJobStatus'] in ['COMPLETED', 'FAILED']:
                break
            print('Translating audio...')
            time.sleep(5)

        response_url = transcribe.get_transcription_job(TranscriptionJobName=self._transcribe_job_name)
        translated_file_url = response_url['TranscriptionJob']['Transcript']['TranscriptFileUri']

        # Download the result of the transcribe job locally
        with urllib.request.urlopen(translated_file_url) as response, open(self._path_transcribe_result_output, 'wb') as out_file:
            shutil.copyfileobj(response, out_file)
        print('Translation done and saved under: ' +
              self._path_transcribe_result_output)

    def _create_srt_file(self):
        # Right now, just opening a local result and process it.
        # Aim - Create phrases of ~10 words and create proper .srt file (3 for this example)
        with open('./transcribe_result.json') as file:
            raw_result = json.load(file)
        # print(raw_result['results']['items'])
        raw_items = raw_result['results']['items']
        # Assume that the items are chronoligically sorted
        for raw_item in raw_items:
            print(raw_item)

    def run(self):
        # self._upload_audio_to_s3()
        # self._transcribe()
        self._create_srt_file()



class SentenceSRT():
	def __init__(self, order=None, start_time=None, end_time=None, words=[]):
		self._order = order
		self._start_time = start_time
		self._end_time = end_time
		self._words = words


def newPhrase():
	return {'start_time': '', 'end_time': '', 'words': []}

def create_srt_file():
	with open('./transcribe_result.json') as file:
		raw_result = json.load(file)

	items = raw_result['results']['items']

	phrase = newPhrase()
	phrases = []
	nPhrase = True
	nb_words = 0
	seq_order = 1 # SRT start with 1

	for item in items:
		#phrase._order = seq_order
		if nPhrase == True:
			if item["type"] == "pronunciation":
				#phrase._start_time = get_timestamp(float(item["start_time"]))
				phrase["start_time"] = get_timestamp(float(item["start_time"]))
				nPhrase = False
		else:
			if item["type"] == "pronunciation":
				#phrase._end_time = get_timestamp(float(item["end_time"]))
				phrase["end_time"] = get_timestamp(float(item["end_time"]))

		#phrase._words.append(item['alternatives'][0]["content"])
		phrase["words"].append(item['alternatives'][0]["content"])
		nb_words += 1

		if nb_words == 3:
			phrases.append(phrase)
			#print(phrase._words)
			#phrase = SentenceSRT()
			phrase = newPhrase()
			nPhrase = True
			nb_words = 0
			# After each sentence, increase seq_order
			seq_order += 1

	for a in phrases:
		print(a)

	# print(phrases[0]._order)
	# print(phrases[0]._start_time)
	# print(' '.join(phrases[0]._words))
	# print(phrases[0]._end_time)

	# print(phrases[1]._order)
	# print(phrases[1]._start_time)
	# print(' '.join(phrases[1]._words))
	# print(phrases[1]._end_time)

	# print(phrases[2]._order)
	# print(phrases[2]._start_time)
	# print(' '.join(phrases[2]._words))
	# print(phrases[2]._end_time)

	# print(phrases[3]._order)
	# print(phrases[3]._start_time)
	# print(' '.join(phrases[3]._words))
	# print(phrases[3]._end_time)

	print('Len = ' +str(len(phrases)))

	#return phrases
"""
  # print(raw_result['results']['items'])
  raw_items = raw_result['results']['items']
  sentences = []
  words = 0
  for raw_item in raw_items:
    if raw_item['type'] == 'pronunciation':
      start_time = get_timestamp(raw_item['start_time'])
      words += 1
      if(words < 3):
        sentences.append(raw_item['alternatives'][0]['content'])
        words = 0
    print(sentences)
"""


"""
1
00: 00: 00, 260 - -> 00: 00: 02, 899
How about language? You know, i talked earlier

2
00: 00: 02, 899 - -> 00: 00: 05, 860
about the fact that last year we launched both Polly
"""


def get_timestamp(seconds):
  seconds = float(seconds)
  thund = int(seconds % 1 * 1000)
  tseconds = int(seconds)
  tsecs = ((float(tseconds) / 60) % 1) * 60
  tmins = int(tseconds / 60)
  return str("%02d:%02d:%02d,%03d" % (00, tmins, int(tsecs), thund))

if __name__ == '__main__':
    # Transcribe('./audio_trimmed.mp3', './transcribe_result.json', 'eu-central-1', 's3-ec1-app-bucket').run()
    create_srt_file()


