import boto3
import time
import string
import random

class VideoFile():
  def __init__(self):
    self._audio_track = self._extract_audio()

  def _extract_audio(self):
    return 0

class Transcribe():
  def __init__(self, path_audio_input, region, bucket):
    self._transcribe_job_name = self._randomize_job_name()
    self._s3_file_name = self._randomize_job_name()+'.mp3'
    self._path_audio_input = path_audio_input
    self._aws_region = region
    self._bucket_name = bucket

  def _randomize_job_name(self):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(6))

  def _upload_audio_to_s3(self):
    s3 = boto3.resource('s3')
    s3.meta.client.upload_file(self._path_audio_input, self._bucket_name, self._s3_file_name)

  def _transcribe(self):
    transcribe = boto3.client('transcribe')
    job_name = self._transcribe_job_name
    job_uri = 'https://'+self._bucket_name+'.s3.'+self._aws_region+'.amazonaws.com/'+self._s3_file_name
    print(job_uri)
    transcribe.start_transcription_job(
        TranscriptionJobName=job_name,
        Media={'MediaFileUri': job_uri},
        MediaFormat='mp3',
        LanguageCode='en-US'
    )

    while True:
      status = transcribe.get_transcription_job(TranscriptionJobName=job_name)
      if status['TranscriptionJob']['TranscriptionJobStatus'] in ['COMPLETED', 'FAILED']:
          break
      print("Not ready yet...")
      time.sleep(5)

    response_url = transcribe.get_transcription_job(TranscriptionJobName = self._transcribe_job_name)
    print(response_url['TranscriptionJob']['Transcript']['TranscriptFileUri'])
    #boto3.client('s3').get_object(Bucket=self._bucket_name, Key='')

  def run(self):
    self._upload_audio_to_s3()
    self._transcribe()


if __name__ == '__main__':
  Transcribe('./audio_trimmed.mp3', 'eu-central-1', 's3-ec1-app-bucket').run()
