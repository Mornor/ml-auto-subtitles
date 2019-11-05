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
  def __init__(self, path_audio_input, region, bucket, result_name):
    self._transcribe_job_name = self._randomize_job_name()
    self._path_audio_input = path_audio_input
    self._aws_region = region
    self._s3_bucket = bucket
    self._result_name = result_name

  def _randomize_job_name(self):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(6))

  def upload_audio_to_s3(self):
    s3 = boto3.resource('s3')
    s3.meta.client.upload_file('./audio_trimmed.mp3', 's3-ec1-app-bucket', 'audio.mp3')

def transcribe():
  transcribe = boto3.client('transcribe')
  job_name = "test_tranlate"
  job_uri = "https://s3-ec1-app-bucket.s3.eu-central-1.amazonaws.com/audio.mp3"
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
  print(status)

#upload_audio_to_s3()
#transcribe()


