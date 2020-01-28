[
  {
    "name": "${container_name}",
    "image": "${container_image}",
    "environment": [{
        "name": "SQS_QUEUE_URL",
        "value": "${sqs_queue_url}"
    }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/fargate/service/extract_sound",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]