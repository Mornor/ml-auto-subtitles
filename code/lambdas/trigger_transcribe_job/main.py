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
    print(variable_name + ' is not set, please check your environment variables')
    exit(-1)
  return result

def handler(event, context):
  # Retrieve bucket name and file_key from the S3 event
  bucket_name = event['Records'][0]['s3']['bucket']['name']
  file_key = event['Records'][0]['s3']['object']['key']
  print('Bucket = ['+bucket_name+']')
  print('File key = ['+file_key+']')

  # Get the region from the env variable
  region = get_env_variable('region')
  result_bucket = get_env_variable('result_bucket')
  language_code = get_env_variable('language_code')
  media_format = get_env_variable('media_format')

  # The file key is already randomized, so we can re-use it. Transcribe does not accept '/' as a job name, so we have to only get the key.
  job_name = os.path.basename(file_key)
  job_uri = 'https://' +bucket_name+ '.s3.' +region+ '.amazonaws.com/' +file_key

  transcribe = boto3.client('transcribe')
  transcribe.start_transcription_job(
      TranscriptionJobName=job_name,
      Media={'MediaFileUri': job_uri},
      OutputBucketName=result_bucket,
      LanguageCode=language_code,
      MediaFormat=media_format
  )

  return None
