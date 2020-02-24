"""
_2nd Lambda to be called_
Triggered when a message is received in the SQS queue
- Launch the ECS task
"""
import boto3
import json
import os

def get_env_variable(variable_name):
  try:
      result = os.environ[variable_name]
  except KeyError:
      print(variable_name + ' is not set, please check your environment variables')
      exit(-1)
  return result

def parse_sqs_message(event):
  # Check that we have data to read from
  if 'Records' not in event:
    print('No Records found in queue.')
    exit(-1)

  # Extract data from the SQS message
  message = event['Records'][0]
  body = json.loads(message['body'])
  bucket = body.get('Bucket', None)
  key = body.get('object_path', None)

  print('Read from SQS: Bucket = ['+bucket+'], key = ['+key+'].')

  # If any of the variables have not been sent exit
  if bucket is None or key is None:
      print('Bucket or key missing from message')
      exit(-1)

  return {
      "bucket": bucket,
      "bucket_key": key
  }

def handler(event, context):
  cluster_name = get_env_variable('cluster_name')
  private_subnet_id = get_env_variable('subnet_id')
  task_defintion_name = get_env_variable('task_definition_name')
  container_name = get_env_variable('container_name')

  # Extract information from SQS
  parsed_message = parse_sqs_message(event)
  bucket = parsed_message['bucket']
  object_path = parsed_message['bucket_key']

  # Launch ECS task and provide bucket and file as env variables
  print('Launching ['+task_defintion_name+'] on the ECS cluster ['+cluster_name+'], running on Subnet ID ['+private_subnet_id+']')
  response = boto3.client("ecs").run_task(
      cluster=cluster_name,
      taskDefinition=task_defintion_name,
      count=1,
      launchType='FARGATE',
      networkConfiguration={
          'awsvpcConfiguration': {
              'subnets': [private_subnet_id],
          }
      },
      overrides = {
          'containerOverrides' : [
            {
                'name': container_name,
                'environment': [
                  {
                    'name': 'bucket',
                    'value': bucket
                  },{
                    'name': 'object_path',
                    'value': object_path
                  }
                ]
            }
          ]
      }
  )

  ecs_task_arn = response['tasks'][0]['taskArn']
  print('Task successfully launched - ['+ecs_task_arn+']')

  return None
