variable "region" {
  type = string
}

variable "publish" {
  type = bool
}

variable "runtime" {
  type = string
}

variable "memory_size" {
  type = number
}

variable "timeout" {
  type = number
}

variable "lambda_input_to_sqs_s3_key" {
  type = string
}

variable "lambda_input_to_sqs_policy_path" {
  type = string
}

variable "lambda_input_to_sqs_description" {
  type = string
}

variable "lambda_input_to_sqs_policy_name" {
  type = string
}

variable "lambda_input_to_sqs_name" {
  type = string
}

variable "lambda_input_to_sqs_handler" {
  type = string
}

variable "lambda_input_to_sqs_input_path" {
  type = string
}

variable "lambda_input_to_sqs_output_path" {
  type = string
}

variable "lambda_trust_policy" {
  type = string
}

variable "sqs_name" {
  type = string
}

variable "sqs_message_retention_seconds" {
  type = number
}

variable "ecr_name" {
  type = string
}

variable "ecs_task_role_name" {
  type = string
}

variable "ecs_trust_policy" {
  type = string
}

variable "ecs_task_name" {
  type = string
}

variable "ecs_type" {
  type = string
}

variable "ecs_cpu" {
  type = string
}

variable "ecs_mem" {
  type = string
}

variable "ecs_definition_path" {
  type = string
}

variable "ecs_task_execution_policy_name" {
  type = string
}

variable "ecs_task_execution_role_name" {
  type = string
}

variable "ecs_task_execution_policy_path" {
  type = string
}

variable "ecs_network_mode" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_launch_type" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "lambda_trigger_ecs_task_input_path" {
  type = string
}

variable "lambda_trigger_ecs_task_output_path" {
  type = string
}

variable "lambda_trigger_ecs_task_policy_path" {
  type = string
}

variable "lambda_trigger_ecs_task_policy_name" {
  type = string
}

variable "lambda_trigger_ecs_task_s3_key" {
  type = string
}

variable "lambda_trigger_ecs_task_name" {
  type = string
}

variable "lambda_trigger_ecs_task_handler" {
  type = string
}

variable "lambda_trigger_ecs_task_description" {
  type = string
}

variable "ecs_container_name" {
  type = string
}

variable "lambda_trigger_transcribe_job_s3_key" {
  type = string
}

variable "lambda_trigger_transcribe_job_policy_path" {
  type = string
}

variable "lambda_trigger_transcribe_job_description" {
  type = string
}

variable "lambda_trigger_transcribe_job_policy_name" {
  type = string
}

variable "lambda_trigger_transcribe_job_name" {
  type = string
}

variable "lambda_trigger_transcribe_job_handler" {
  type = string
}

variable "lambda_trigger_transcribe_job_input_path" {
  type = string
}

variable "lambda_trigger_transcribe_job_output_path" {
  type = string
}

variable "lambda_parse_transcribe_result_s3_key" {
  type = string
}

variable "lambda_parse_transcribe_result_policy_path" {
  type = string
}

variable "lambda_parse_transcribe_result_description" {
  type = string
}

variable "lambda_parse_transcribe_result_policy_name" {
  type = string
}

variable "lambda_parse_transcribe_result_name" {
  type = string
}

variable "lambda_parse_transcribe_result_handler" {
  type = string
}

variable "lambda_parse_transcribe_result_input_path" {
  type = string
}

variable "lambda_parse_transcribe_result_output_path" {
  type = string
}