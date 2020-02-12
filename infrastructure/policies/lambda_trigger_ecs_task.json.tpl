{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:RunTask",
                "ecs:StopTask",
                "ecs:DescribeTasks"
            ],
            "Condition": {
              "ArnEquals": {
                "ecs:cluster": "${ecs_cluster_arn}"
              }
            },
            "Resource": [
                "${task_definition_arn}"
            ]
        }
    ]
}