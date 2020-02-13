"""
_1st Lambda to be called_
Triggered when the video file is uploaded into the Bucket under /inputs
- Retrieve the name of the video file which has been uploaded
- Send a message to the SQS queue with the name of the file along with the bucket
"""

import boto3
import json
import os

def handler(event, context):
  # Retrieve bucket name and file_key from the S3 event
  bucket_name = event['Records'][0]['s3']['bucket']['name']
  file_key = event['Records'][0]['s3']['object']['key']

  print('Bucket = ' +bucket_name)
  print('File key = ' +file_key)

  # Define message to be sent to the SQS
  message = {
    "Bucket": bucket_name,
    "object_path": file_key
  }

  # Insert message into SQS
  sqs_client = boto3.client('sqs')
  sqs_client.send_message(
      QueueUrl=os.environ['queue_url'],
      MessageBody=json.dumps(message)
  )
  print('SQS message inserted in SQS')

  return None
