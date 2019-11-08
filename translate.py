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


def create_srt_file():
  with open('./transcribe_result.json') as file:
    raw_result = json.load(file)
  # print(raw_result['results']['items'])
  raw_items = raw_result['results']['items']
  for raw_item in raw_items:
    if raw_item['type'] == 'pronunciation':
      timestamp = get_timestamp(raw_item['start_time'])
      print(timestamp)
    #print(raw_item['start_time'])


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


