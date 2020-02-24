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

  # Retrieve SQS Queue URL
  sqs_queue = os.environ['queue_url']

  print('Bucket = ['+bucket_name+']')
  print('File key = ['+file_key+']')

  # Define message to be sent to the SQS
  message = {
    "Bucket": bucket_name,
    "object_path": file_key
  }

  # Insert message into SQS
  sqs_client = boto3.client('sqs')
  response = sqs_client.send_message(
      QueueUrl=sqs_queue,
      MessageBody=json.dumps(message)
  )

  # Check if message has been correctly sent
  if 'MessageId' not in response:
    print('Error, cannot fetch the MessageId of the message which has been sent.')
    exit(-1)
  else:
    print('SQS message successfully inserted in SQS queue ['+sqs_queue+']')

  return None