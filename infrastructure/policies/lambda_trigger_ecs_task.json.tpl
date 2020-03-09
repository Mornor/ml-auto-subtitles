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
                "arn:aws:ecs:${region}:${account_id}:task-definition/${task_definition_name}"
            ]
        },{
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
               "${ecs_task_execution_role_arn}",
               "${ecs_task_role_arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes"
            ],
            "Resource": [
                "${sqs_arn}"
            ]
        },{
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "*"
            ]
        },{
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}