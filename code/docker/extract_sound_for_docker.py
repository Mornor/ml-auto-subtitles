import boto3
import string
import random
import botocore
import os
from botocore.exceptions import ClientError
from moviepy.editor import AudioFileClip

def randomize_job_name():
  letters = string.ascii_lowercase
  return ''.join(random.choice(letters) for i in range(6))

def get_env_variable(variable_name):
  try:
      result = os.environ[variable_name]
  except KeyError:
      raise Exception(variable_name+ ' is not set, please check your ECS environment variables')
  return result

def get_file_from_s3(bucket, s3_key, tmp_local_file_name):
  print('Downloading from S3: '+bucket+'/'+s3_key)
  s3 = boto3.resource('s3')
  try:
    s3.meta.client.download_file(bucket, s3_key, './'+tmp_local_file_name+'.mp4')
  except botocore.exceptions.ClientError as e:
    if e.response['Error']['Code'] == '404':
        print('The object '+s3_key+' does not exist in the Bucket ['+bucket+'].')
    else:
        print('Error when downloading S3 object: '+e)
    print('Remvoving message from SQS')

  tmp_path = './'+tmp_local_file_name+'.mp4'
  print('File downloaded into '+tmp_path)
  return tmp_path

def extract_sound_from_video(video_path, output_path):
  print('Extracting sound from video ['+video_path+']')
  audio = AudioFileClip(video_path)
  audio.write_audiofile('./'+output_path+'.mp3')
  print('Sound extracted and saved under [./'+output_path+'.mp3]')

def upload_sound_to_s3(bucket, file_name):
  print('Uploading extracted sound ['+file_name+'.mp3] to S3')
  s3 = boto3.resource('s3')
  s3.meta.client.upload_file('./'+file_name+'.mp3', bucket, 'tmp/'+file_name+'.mp3')
  print('Sound uploaded to Bucket ['+bucket+'] under [tmp/'+file_name+'.mp3]')

def run():
  print('Getting meesage from Lambda')
  bucket = get_env_variable('bucket')
  object_path = get_env_variable('object_path')
  print('Bucket = ', bucket)
  print('object_path = ', object_path)
  randomized_file_name = randomize_job_name()
  tmp_video_path = get_file_from_s3(bucket, object_path, randomized_file_name)
  extract_sound_from_video(tmp_video_path, randomized_file_name)
  upload_sound_to_s3(bucket, randomized_file_name)

run()
