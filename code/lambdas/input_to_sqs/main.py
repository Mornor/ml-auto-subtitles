import boto3
import os

def handler(event, context):
  # Retrieve bucket name and file_key from the S3 event
  bucket_name = event['Records'][0]['s3']['bucket']['name']
  file_key = event['Records'][0]['s3']['object']['key']

  print('Bucket = ' + bucket_name)
  print('File key = ' + file_key)

  # Insert S3 file path into SQS
  sqs_client = boto3.client('sqs')
  sqs_client.send_message(
      QueueUrl=os.environ['queue_url'],
      MessageBody=bucket_name+'/'+file_key,
  )
  print('SQS message inserted in SQS FIFO')

  return None
