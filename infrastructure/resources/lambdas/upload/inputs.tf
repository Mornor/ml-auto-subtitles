variable "lambda_path_input" {
  type = string
}

variable "lambda_path_output" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "lambda_s3_key" {
  type = string
}

variable "lambda_name" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "memory_size" {
  type = string
}

variable "timeout" {
  type = number
}

variable "role_arn" {
  type = number
}

variable "publish" {
  type = bool
}

variable "tags" {
  type = maps
}

variable "environment_variables" {
  type = map
}