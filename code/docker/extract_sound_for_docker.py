import boto3
import string
import random
import botocore
import os
from botocore.exceptions import ClientError
from moviepy.editor import AudioFileClip

# Return a 6 chars string
def randomize_job_name():
  letters = string.ascii_lowercase
  return ''.join(random.choice(letters) for i in range(6))

def get_env_variable(variable_name):
  try:
      result = os.environ[variable_name]
  except KeyError:
      print(variable_name+ ' is not set, please check your ECS environment variables')
      exit(-1)
  return result

def get_file_from_s3(bucket, s3_key, tmp_local_file_name):
  print('Downloading from S3: ['+bucket+'/'+s3_key+']')
  s3 = boto3.resource('s3')
  raw_input_name = os.path.splitext(os.path.basename(s3_key))[0] # inputs/xxxxx.yyy -> xxxx
  _, file_extension = os.path.splitext(s3_key)  # inputs/xxxxx.yyy -> .yyy
  tmp_path = './'+raw_input_name+'_'+tmp_local_file_name+file_extension
  try:
    # Download into './[input_name]_[random_string].[file_extension]'
    s3.meta.client.download_file(bucket, s3_key, tmp_path)
  except botocore.exceptions.ClientError as e:
    if e.response['Error']['Code'] == '404':
      print('The object ['+s3_key+'] does not exist in the Bucket ['+bucket+']')
      exit(-1)
    else:
      print('Error when downloading S3 object: '+e)
      exit(-1)

  print('File locally downloaded under ['+tmp_path+']')
  return tmp_path

def extract_sound_from_video(video_path): #[s3_key]_[randomized_file_name]
  print('Extracting sound from video ['+video_path+']')
  # ./[input_name]_[random_string].[file_extension] -> ./[input_name]_[random_string].mp3
  tmp_extracted_sound_path = './'+os.path.basename(video_path).split('.')[0]+'.mp3'
  audio = AudioFileClip(video_path)
  audio.write_audiofile(tmp_extracted_sound_path)
  print('Sound extracted and saved under ['+tmp_extracted_sound_path+']')
  return tmp_extracted_sound_path

def upload_sound_to_s3(bucket, tmp_extracted_sound_path):
  print('Uploading extracted sound ['+tmp_extracted_sound_path+'] to S3')
  raw_file_name = os.path.basename(tmp_extracted_sound_path)
  s3 = boto3.resource('s3')
  try:
    s3.meta.client.upload_file(tmp_extracted_sound_path, bucket, 'tmp/'+raw_file_name)
  except boto3.exceptions.S3UploadFailedError as e:
    print('Upload of the extracted sound failed: '+e)
    exit(-1)
  print('Sound uploaded to Bucket ['+bucket+'] under [tmp/'+raw_file_name+']')

def remove_input_file(bucket, key):
  print('Deleting input file ['+key+'] from S3 ['+bucket+']')
  s3 = boto3.client('s3')
  s3.delete_object(Bucket=bucket, Key=key)
  print('Input file ['+key+'] successfully deleted from S3 ['+bucket+']')

def run():
  # Get the message's data from the Lambda function
  print('Reading message data from Lambda')
  bucket = get_env_variable('bucket')
  object_path = get_env_variable('object_path')
  print('Bucket = ['+bucket+']')
  print('object_path = ['+object_path+']')

  # Randomize a job name for both the Transcript job and the filename of the extracted sound from the video
  randomized_file_name = randomize_job_name()

  # Locally download the file from S3 and return its local path ('./[s3_key]_[randomized_file_name].[file_extension]')
  tmp_video_path = get_file_from_s3(bucket, object_path, randomized_file_name)

  # Extract the sound from the downloaded video and return its local path ('./[s3_key]_[randomized_file_name].mp3')
  tmp_extracted_sound_path = extract_sound_from_video(tmp_video_path)

  # Upload the extracted sound to the app-bucket under /tmp/randomized_file_name]/.mp3
  upload_sound_to_s3(bucket, tmp_extracted_sound_path)

  # Remove input video file once the sound is extracted
  remove_input_file(bucket, object_path)

run()
