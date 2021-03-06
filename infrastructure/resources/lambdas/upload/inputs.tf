variable "lambda_path_input" {
  type = string
}

variable "lambda_path_output" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "bucket_arn" {
  type = string
  default = ""
}

variable "lambda_s3_key" {
  type = string
}

variable "lambda_name" {
  type = string
}

variable "description" {
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
  type = string
}

variable "publish" {
  type = bool
}

variable "subnet_ids" {
  type = list(string)
}

variable "sg_ids" {
  type = list(string)
}

variable "tags" {
  type = map
}

variable "environment_variables" {
  type = map
}