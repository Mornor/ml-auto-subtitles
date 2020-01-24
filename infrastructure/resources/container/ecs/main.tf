resource "aws_ecs_task_definition" "this" {
  family                   = var.ecs_task_name
  requires_compatibilities = [var.ecs_type]
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_mem
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.var.ecs_execution_role_arn

  container_definitions = <<DEFINITION
[
  {
    "name": "${var.container_name}",
    "image": "${var.default_backend_image}",
    "essential": true,
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port}
      }
    ],
    "environment": [
      {
        "name": "PORT",
        "value": "${var.container_port}"
      },
      {
        "name": "HEALTHCHECK",
        "value": "${var.health_check}"
      },
      {
        "name": "ENABLE_LOGGING",
        "value": "false"
      },
      {
        "name": "PRODUCT",
        "value": "${var.app}"
      },
      {
        "name": "ENVIRONMENT",
        "value": "${var.environment}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/fargate/service/${var.app}-${var.environment}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION


  tags = var.tags
}