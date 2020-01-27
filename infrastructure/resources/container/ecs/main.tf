resource "aws_ecs_task_definition" "this" {
  family                   = var.ecs_task_name
  requires_compatibilities = [var.ecs_type]
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_mem
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
  container_definitions    = var.ecs_definition
}