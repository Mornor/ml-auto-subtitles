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

variable "ecs_task_role_arn" {
  type = string
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "ecs_task_definition" {
  type = any
}