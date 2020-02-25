"""
_4th_ Lambda to be called
Triggered when the Transcribe job is finished.
- Fetch the result from the Transcribe job
- Parse it to a .srt format
- Upload it to the app bucket under /outputs
"""

import botocore
import boto3
import json
import os

def get_timestamp(seconds):
  seconds = float(seconds)
  thund = int(seconds % 1 * 1000)
  tseconds = int(seconds)
  tsecs = ((float(tseconds) / 60) % 1) * 60
  tmins = int(tseconds / 60)
  return str("%02d:%02d:%02d,%03d" % (00, tmins, int(tsecs), thund))

def write_srt_file(phrases, key):
  # xxxx.mp3.json to xxxx
  key = key.split('.')[0]
  final_result_tmp_file = '/tmp/subtitles_'+key+'.srt'
  with open(final_result_tmp_file, 'w+') as out_file:
    for phrase in phrases:
      out_file.write(str(phrase['seq_order']))
      out_file.write('\n')
      out_file.write(str(phrase['start_time']) + ' --> ' + str(phrase['end_time']))
      out_file.write('\n')
      out_file.write(' '.join(phrase['words']))
      out_file.write('\n\n')
  print('Translation done and saved under: ['+final_result_tmp_file+']')
  return final_result_tmp_file

def new_phrase():
  return {'seq_order': '', 'start_time': '', 'end_time': '', 'words': []}

def download_transribe_result(bucket, key):
  print('Downloading AWS Transcribe result')
  s3 = boto3.resource('s3')
  tmp_filename = '/tmp/'+os.path.basename(key)

  try:
    s3.meta.client.download_file(Bucket=bucket, Key=key, Filename=tmp_filename)
  except botocore.exceptions.ClientError as e:
    if e.response['Error']['Code'] == '404':
      print('The object ['+key+'] does not exist in the Bucket ['+bucket+']')
      exit(-1)
    else:
      print('Error when downloading S3 object: '+e)
      exit(-1)

  print('Downloaded file into ['+tmp_filename+']')
  return tmp_filename

def upload_parsed_result(result_path, bucket):
  s3 = boto3.resource('s3')
  s3.meta.client.upload_file(result_path, bucket, 'results/'+os.path.basename(result_path))
  print('Final result uploaded to ['+bucket+'] under [results/'+os.path.basename(result_path)+'].')

def parse_transcribe_result(tmp_filename):
  with open(tmp_filename) as file:
    raw_result = json.load(file)

  items = raw_result['results']['items']

  phrase = new_phrase()
  phrases = []
  nPhrase = True
  nb_words = 0
  seq_order = 1  # SRT start with 1

  for item in items:
    if nPhrase == True:
      if item['type'] == 'pronunciation':
        phrase['start_time'] = get_timestamp(float(item['start_time']))
        nPhrase = False
    else:
      if item['type'] == 'pronunciation':
        phrase['end_time'] = get_timestamp(float(item['end_time']))

    phrase['seq_order'] = seq_order
    phrase['words'].append(item['alternatives'][0]['content'])
    nb_words += 1

    if nb_words == 5:
      phrases.append(phrase)
      phrase = new_phrase()
      nPhrase = True
      nb_words = 0
      seq_order += 1

  return phrases

def handler(event, context):
  # Check that we have data to read from the event
  if 'Records' not in event:
    print('No Records found in S3 event.')
    exit(-1)

  # Retrieve bucket name and file_key from the S3 event
  bucket_name = event['Records'][0]['s3']['bucket']['name']
  file_key = event['Records'][0]['s3']['object']['key']
  print('Bucket = ['+bucket_name+']')
  print('File key = ['+file_key+']')

  # Localy download the result of the Transcribe job
  tmp_filename = download_transribe_result(bucket_name, file_key)

  # Parse the result
  phrases = parse_transcribe_result(tmp_filename)

  # Save it to a local file
  tmp_result_file = write_srt_file(phrases, file_key)

  # Upload it to S3
  upload_parsed_result(tmp_result_file, bucket_name)

  return None
