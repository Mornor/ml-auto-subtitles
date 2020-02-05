# General attributes
region = "eu-central-1"

# General Lambdas attributes
runtime             = "python3.7"
publish             = false
memory_size         = 256
timeout             = 5
lambda_trust_policy = "../../policies/lambda_trust_policy.json"

# Specific Lambdas attributes
lambda_input_to_sqs_input_path              = "../../../code/lambdas/input_to_sqs/main.py"
lambda_input_to_sqs_output_path             = "../../../code/lambdas/input_to_sqs/input_to_sqs.zip"
lambda_input_to_sqs_policy_path             = "../../policies/lambda_access_s3_sqs.json.tpl"
lambda_input_to_sqs_s3_event_filter_prefix  = "inputs/"
lambda_input_to_sqs_policy_name             = "policy_lambda_input_to_sqs"
lambda_input_to_sqs_s3_key                  = "input_to_sqs/input_to_sqs.zip"
lambda_input_to_sqs_name                    = "input_to_sqs"
lambda_input_to_sqs_handler                 = "main.handler"
lambda_input_to_sqs_description             = "Push S3 file path from /input to SQS"

# SQS attribute
sqs_name                      = "sqs_input"
sqs_message_retention_seconds = 345600

# ECR attributes
ecr_name = "ecr_media_processing"

# ECS Cluster
ecs_cluster_name = "extract_sound_cluster"

# ECS attributes
ecs_task_name       = "extract_sound"
ecs_type            = "FARGATE"
ecs_cpu             = 256
ecs_mem             = 512
ecs_definition_path = "../../ecs_definition/ecs_definition.json.tpl"
ecs_network_mode    = "awsvpc"

# ECS IAM
ecs_task_role_name              = "ecs_task_role"
ecs_task_execution_policy_name  = "policy_ecs_task_execution_role"
ecs_task_execution_role_name    = "ecs_task_execution"
ecs_trust_policy                = "../../policies/ecs_trust_policy.json"
ecs_task_execution_policy_path  = "../../policies/ecs_task_execution_policy.json.tpl"

# ECS service
ecs_service_name         = "ecs_service"
ecs_service_launch_type  = "FARGATE"