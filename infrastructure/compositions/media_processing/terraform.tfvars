# General attributes
region = "eu-central-1"

# General Lambdas attributes
runtime             = "python3.7"
publish             = false
memory_size         = 256
timeout             = 300
lambda_trust_policy = "../../policies/lambda_trust_policy.json"

# Specific Lambdas attributes - Lambda triggered by a object created in S3 of the app_bucket (under /inputs) and put a message into SQS
lambda_input_to_sqs_input_path  = "../../../code/lambdas/input_to_sqs/main.py"
lambda_input_to_sqs_output_path = "../../../code/lambdas/input_to_sqs/input_to_sqs.zip"
lambda_input_to_sqs_policy_path = "../../policies/lambda_access_s3_sqs.json.tpl"
lambda_input_to_sqs_policy_name = "policy_lambda_input_to_sqs"
lambda_input_to_sqs_s3_key      = "input_to_sqs/input_to_sqs.zip"
lambda_input_to_sqs_name        = "input_to_sqs"
lambda_input_to_sqs_handler     = "main.handler"
lambda_input_to_sqs_description = "Push S3 file path from /input to SQS"

# Specific Lambdas attributes - Lambda triggered by a message received in SQS and trigger the ECS task
lambda_trigger_ecs_task_input_path  = "../../../code/lambdas/trigger_ecs_task/main.py"
lambda_trigger_ecs_task_output_path = "../../../code/lambdas/trigger_ecs_task/trigger_ecs_task.zip"
lambda_trigger_ecs_task_policy_path = "../../policies/lambda_trigger_ecs_task.json.tpl"
lambda_trigger_ecs_task_policy_name = "policy_lambda_trigger_ecs_task"
lambda_trigger_ecs_task_s3_key      = "trigger_ecs_task/trigger_ecs_task.zip"
lambda_trigger_ecs_task_name        = "trigger_ecs_task"
lambda_trigger_ecs_task_handler     = "main.handler"
lambda_trigger_ecs_task_description = "Trigger ECS task when a message is received in the SQS Queue"

# Specific Lambdas attributes - Lambda triggered by a object created in S3 of the app_bucket (under /tmp) and trigger the Transcribe job
lambda_trigger_transcribe_job_input_path       = "../../../code/lambdas/trigger_transcribe_job/main.py"
lambda_trigger_transcribe_job_output_path      = "../../../code/lambdas/trigger_transcribe_job/trigger_transcribe_job.zip"
lambda_trigger_transcribe_job_policy_path      = "../../policies/lambda_trigger_transcribe_job.json.tpl"
lambda_trigger_transcribe_job_policy_name      = "policy_lambda_trigger_transcribe_job"
lambda_trigger_transcribe_job_s3_key           = "trigger_transcribe_job/trigger_transcribe_job.zip"
lambda_trigger_transcribe_job_name             = "trigger_transcribe_job"
lambda_trigger_transcribe_job_handler          = "main.handler"
lambda_trigger_transcribe_job_description      = "Trigger Transcribe job when a object is created under /tmp of the app bucket"
lambda_trigger_transcribe_job_env_language     = "en-US"

# Specific Lambdas attributes - Lambda triggered by a object created in S3 of the transcribe_results_bucket and parse the Transcribe result into a .srt file.
lambda_parse_transcribe_result_input_path  = "../../../code/lambdas/parse_transcribe_result/main.py"
lambda_parse_transcribe_result_output_path = "../../../code/lambdas/parse_transcribe_result/parse_transcribe_result.zip"
lambda_parse_transcribe_result_policy_path = "../../policies/lambda_parse_transcribe_result.json.tpl"
lambda_parse_transcribe_result_policy_name = "policy_lambda_parse_transcribe_result"
lambda_parse_transcribe_result_s3_key      = "parse_transcribe_result/parse_transcribe_result.zip"
lambda_parse_transcribe_result_name        = "parse_transcribe_result"
lambda_parse_transcribe_result_handler     = "main.handler"
lambda_parse_transcribe_result_description = "Parse the result of the Transcribe job into a .srt file"

# SQS attribute
sqs_name                      = "sqs_input"
sqs_message_retention_seconds = 345600

# ECR attributes
ecr_name = "ecr_media_processing"

# ECS Cluster
ecs_cluster_name = "extract_sound_cluster"

# ECS attributes
ecs_task_name       = "extract_sound"
ecs_container_name  = "extract_sound_from_video"
ecs_type            = "FARGATE"
ecs_cpu             = 256
ecs_mem             = 512
ecs_definition_path = "../../ecs_definition/ecs_definition.json.tpl"
ecs_network_mode    = "awsvpc"

# ECS IAM
ecs_task_role_name             = "ecs_task_role"
ecs_task_execution_policy_name = "policy_ecs_task_execution_role"
ecs_task_execution_role_name   = "ecs_task_execution"
ecs_trust_policy               = "../../policies/ecs_trust_policy.json"
ecs_task_execution_policy_path = "../../policies/ecs_task_execution_policy.json.tpl"

# ECS service
ecs_service_name        = "ecs_service"
ecs_service_launch_type = "FARGATE"