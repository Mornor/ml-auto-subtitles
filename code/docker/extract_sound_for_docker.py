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

def get_data_from_sqs(queue_url):
  client = boto3.client('sqs')
  response = client.receive_message(
      QueueUrl=queue_url,
      MaxNumberOfMessages=1,
      WaitTimeSeconds=20
  )
  return response

def parse_sqs_message(response_sqs_message):
  if 'Messages' not in response_sqs_message:
      print('No messages found in queue')
      return None

  # Body is like [bucket]/[s3_key]
  message = response_sqs_message['Messages'][0]
  receipt_handle = message['ReceiptHandle']
  body = message['Body']
  bucket = body.split('/')[0]
  key = body.split('/')[1] +'/'+ body.split('/')[2]

  # If any of the variables have not been sent exit
  if bucket is None or key is None:
    print('SQS message missing value: Bucket = '+bucket+', key = '+key)
    print('Removing message from queue. Resubmit config to retry')
    return 'Error'

  return bucket, key, receipt_handle

def get_env_variable(variable_name):
  try:
      result = os.environ[variable_name]
  except KeyError:
      raise Exception(variable_name+ ' is not set, please check your ECS environment variables')
  return result

def remove_message_from_queue(receipt_handle):
  print('Removing message from queue. Receipt handle: '+receipt_handle)
  try:
      sqs_queue_url = get_env_variable('SQS_QUEUE_URL')
  except Exception as e:
      raise e
  boto3.client('sqs').delete_message(QueueUrl=sqs_queue_url, ReceiptHandle=receipt_handle)


def get_file_from_s3(bucket, s3_key, receipt_handle, tmp_local_file_name):
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
    remove_message_from_queue(receipt_handle)

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
  print('Getting meesage from SQS - '+get_env_variable('SQS_QUEUE_URL'))
  sqs_message = get_data_from_sqs(get_env_variable('SQS_QUEUE_URL'))
  if 'Messages' not in sqs_message:
        print('No messages found in queue')
        exit(-1)
  bucket, key, receipt_handle = parse_sqs_message(sqs_message)
  randomized_file_name = randomize_job_name()
  tmp_video_path = get_file_from_s3(bucket, key, receipt_handle, randomized_file_name)
  extract_sound_from_video(tmp_video_path, randomized_file_name)
  upload_sound_to_s3(bucket, randomized_file_name)

run()
