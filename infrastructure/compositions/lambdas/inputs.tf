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

variable "lambda_extract_sound_s3_key" {
  type = string
}

variable "lambda_extract_sound_policy_path" {
  type = string
}

variable "lambda_extract_sound_description" {
  type = string
}

variable "lambda_extract_sound_policy_name" {
  type = string
}

variable "lambda_extract_sound_name" {
  type = string
}

variable "lambda_extract_sound_handler" {
  type = string
}

variable "lambda_extract_sound_input_path" {
  type = string
}

variable "lambda_extract_sound_output_path" {
  type = string
}

variable "lambda_trust_policy" {
  type = string
}