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

variable "lambda_input_to_sqs_s3_event_filter_prefix" {
  type = string
}

variable "sqs_name" {
  type = string
}

variable "sqs_message_retention_seconds" {
  type = number
}