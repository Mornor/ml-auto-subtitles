import transcribe

if __name__ == '__main__':
    transcribe.Transcribe('./assets/audio_trimmed.mp3', './transcribe_result.json','eu-central-1', 's3-ec1-app-bucket').run()

# class Transcribe():
#     def __init__(self, path_audio_input, path_transcribe_result_output, region, bucket):
#         self._transcribe_job_name = self._randomize_job_name()
#         self._s3_file_name = self._randomize_job_name()+'.mp3'
#         self._path_audio_input = path_audio_input
#         self._aws_region = region
#         self._bucket_name = bucket
#         self._path_transcribe_result_output = path_transcribe_result_output

#     def _randomize_job_name(self):
#         letters = string.ascii_lowercase
#         return ''.join(random.choice(letters) for i in range(6))

#     def _upload_audio_to_s3(self):
#         s3 = boto3.resource('s3')
#         s3.meta.client.upload_file(self._path_audio_input, self._bucket_name, self._s3_file_name)

#     def _transcribe(self):
#         transcribe = boto3.client('transcribe')
#         job_name = self._transcribe_job_name
#         job_uri = 'https://'+self._bucket_name+'.s3.' + \
#             self._aws_region+'.amazonaws.com/'+self._s3_file_name
#         transcribe.start_transcription_job(
#             TranscriptionJobName=job_name,
#             Media={'MediaFileUri': job_uri},
#             MediaFormat='mp3',
#             LanguageCode='en-US'
#         )

#         while True:
#             status = transcribe.get_transcription_job(
#                 TranscriptionJobName=job_name)
#             if status['TranscriptionJob']['TranscriptionJobStatus'] in ['COMPLETED', 'FAILED']:
#                 break
#             print('Translating audio...')
#             time.sleep(5)

#         response_url = transcribe.get_transcription_job(TranscriptionJobName=self._transcribe_job_name)
#         translated_file_url = response_url['TranscriptionJob']['Transcript']['TranscriptFileUri']

#         # Download the result of the transcribe job locally
#         with urllib.request.urlopen(translated_file_url) as response, open(self._path_transcribe_result_output, 'wb') as out_file:
#             shutil.copyfileobj(response, out_file)
#         print('Translation done and saved under: ' +
#               self._path_transcribe_result_output)

#     def new_phrase(self):
# 	    return {'seq_order': '', 'start_time': '', 'end_time': '', 'words': []}


#     def get_timestamp(self, seconds):
#         seconds = float(seconds)
#         thund = int(seconds % 1 * 1000)
#         tseconds = int(seconds)
#         tsecs = ((float(tseconds) / 60) % 1) * 60
#         tmins = int(tseconds / 60)
#         return str("%02d:%02d:%02d,%03d" % (00, tmins, int(tsecs), thund))

#     def _create_srt_file(self):
#         with open('./transcribe_result.json') as file:
#             raw_result = json.load(file)

#         items = raw_result['results']['items']

#         phrase = self.new_phrase()
#         phrases = []
#         nPhrase = True
#         nb_words = 0
#         seq_order = 1  # SRT start with 1

#         for item in items:
#             if nPhrase == True:
#                 if item['type'] == 'pronunciation':
#                     phrase['start_time'] = self.get_timestamp(float(item['start_time']))
#                     nPhrase = False
#             else:
#                 if item['type'] == 'pronunciation':
#                     phrase['end_time'] = self.get_timestamp(float(item['end_time']))

#             phrase['seq_order'] = seq_order
#             phrase['words'].append(item['alternatives'][0]['content'])
#             nb_words += 1

#             if nb_words == 3:
#                 phrases.append(phrase)
#                 phrase = self.new_phrase()
#                 nPhrase = True
#                 nb_words = 0
#                 seq_order += 1

#         with open('./subtitles.srt', 'w+') as out_file:
#             for phrase in phrases:
#                 out_file.write(str(phrase['seq_order']))
#                 out_file.write('\n')
#                 out_file.write(str(phrase['start_time']) + ' --> ' + str(phrase['end_time']))
#                 out_file.write('\n')
#                 out_file.write(' '.join(phrase['words']))
#                 out_file.write('\n\n')

#     def run(self):
#         self._create_srt_file()



