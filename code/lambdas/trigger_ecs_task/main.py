"""
_2nd Lambda to be called_
Triggered when a message is received in the SQS queue
- Launch the ECS task
"""
import boto3
import os

# TASK_DEFINITION_NAME = "extract_sound"
# CLUSTER_NAME = "extract_sound_cluster"
# private_subnet_id = get_env_variable('SUBNET_ID')

def get_env_variable(variable_name):
  try:
      result = os.environ[variable_name]
  except KeyError:
      raise Exception(variable_name + ' is not set, please check your environment variables')
  return result

def handler(event, context):
  cluster_name = get_env_variable('cluster_name')
  private_subnet_id = get_env_variable('subnet_id')
  task_defintion_name = get_env_variable('task_definition_name')

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
      }
  )

  ecs_task_arn = response['tasks'][0]['taskArn']
  print('Task successfully launched - ['+ecs_task_arn+']')

  return None

# Works
# def run_test():
#   cluster_name = "extract_sound_cluster"
#   private_subnet_id = ["subnet-05e51f78eb8139d6a"]
#   task_defintion_name = "extract_sound"
#   # task_sg = get_env_variable('sg_ecs_task')

#   response = boto3.client("ecs").run_task(
#       cluster=cluster_name,
#       taskDefinition=task_defintion_name,
#       count=1,
#       launchType='FARGATE',
#       networkConfiguration={
#           'awsvpcConfiguration': {
#               'subnets': private_subnet_id,
#           }
#       }
#   )

#   print(response['tasks'][0]['taskArn'])
