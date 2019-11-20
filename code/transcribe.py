import utils
import aws_interact
import urllib
import shutil

class Transcribe():
    def __init__(self, path_audio_input, path_transcribe_result_output, region, bucket):
        self.utils = utils.Utils()
        self.transcribe_job_name = self.utils.randomize_job_name()
        self.s3_file_name = self.utils.randomize_job_name()+'.mp3'
        self.path_audio_input = path_audio_input
        self.aws_region = region
        self.bucket_name = bucket
        self._path_transcribe_result_output = path_transcribe_result_output
        self.aws_interract = aws_interact.AwsInteract('eu-central-1', self.path_audio_input, bucket, self.s3_file_name)

    def _transcribe_and_save_result(self):
        transcribe_result = self.aws_interract.transribe(self.transcribe_job_name)
        with urllib.request.urlopen(transcribe_result) as response, open(self._path_transcribe_result_output, 'wb') as out_file:
            shutil.copyfileobj(response, out_file)
        print('Translation done and saved under: ' +self._path_transcribe_result_output)

    def _new_phrase(self):
	    return {'seq_order': '', 'start_time': '', 'end_time': '', 'words': []}

    def _create_srt_file(self):
        with open(self._path_transcribe_result_output) as file:
            raw_result = json.load(file)

        items = raw_result['results']['items']

        phrase = self.new_phrase()
        phrases = []
        nPhrase = True
        nb_words = 0
        seq_order = 1  # SRT start with 1

        for item in items:
            if nPhrase == True:
                if item['type'] == 'pronunciation':
                    phrase['start_time'] = self.utils.get_timestamp(float(item['start_time']))
                    nPhrase = False
            else:
                if item['type'] == 'pronunciation':
                    phrase['end_time'] = self.utils.get_timestamp(float(item['end_time']))

            phrase['seq_order'] = seq_order
            phrase['words'].append(item['alternatives'][0]['content'])
            nb_words += 1

            if nb_words == 3:
                phrases.append(phrase)
                phrase = self.new_phrase()
                nPhrase = True
                nb_words = 0
                seq_order += 1

        with open('./subtitles.srt', 'w+') as out_file:
            for phrase in phrases:
                out_file.write(str(phrase['seq_order']))
                out_file.write('\n')
                out_file.write(str(phrase['start_time']) + ' --> ' + str(phrase['end_time']))
                out_file.write('\n')
                out_file.write(' '.join(phrase['words']))
                out_file.write('\n\n')
