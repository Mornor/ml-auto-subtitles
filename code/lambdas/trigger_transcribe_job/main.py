"""
_3rd Lambda to be called_
Triggered when a object is put into /tmp (which in this case is the extracted sound from the video)
- Retrieve the name of the sound that's been extracted
- Trigger the AWS Transcribe job
"""

import boto3
import time
import os

def get_env_variable(variable_name):
  try:
    result = os.environ[variable_name]
  except KeyError:
    raise Exception(variable_name + ' is not set, please check your environment variables')
  return result

def handler(event, context):
  transcribe = boto3.client('transcribe')
  # Retrieve bucket name and file_key from the S3 event
  bucket_name = event['Records'][0]['s3']['bucket']['name']
  file_key = event['Records'][0]['s3']['object']['key']

  # Get the region from the env variable
  region = get_env_variable('region')

  # The file key is already randomized, so we can re-use it
  job_name = file_key
  job_uri = 'https://' +bucket_name+ '.s3.' +region+ '.amazonaws.com/' +file_key

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
      print('Translating audio...')
      time.sleep(5)

  response_url = transcribe.get_transcription_job(TranscriptionJobName=job_name)
  translated_file_url = response_url['TranscriptionJob']['Transcript']['TranscriptFileUri']

  return None
