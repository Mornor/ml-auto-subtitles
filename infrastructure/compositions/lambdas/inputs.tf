variable "region" {
  type = string
}

variable "lambda_extract_sound_s3_key" {
  type = string
}

variable "lambda_extract_sound_lambda_name" {
  type = string
}

variable "lambda_extract_sound_handler" {
  type = string
}

variable "lambda_extract_sound_runtime" {
  type = string
}

variable "lambda_extract_sound_mem_size" {
  type = string
}

variable "lambda_extract_sound_timeout" {
  type = number
}

variable "lambda_extract_sound_input_path" {
  type = string
}

variable "lambda_extract_sound_output_path" {
  type = string
}

variable "lambda_extract_sound_publish" {
  type = bool
}

variable "lambda_trust_policy" {
  type = string
}