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
