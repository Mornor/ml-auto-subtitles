[
  {
    "name": "${var.container_name}",
    "image": "${var.container_image}",
    "environment": [{
        "name": "SQS_QUEUE_URL",
        "value": "${var.sqs_queue_url}"
    }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/fargate/service/${var.app}-${var.environment}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]