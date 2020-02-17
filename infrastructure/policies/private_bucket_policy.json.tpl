{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${account_id}:root"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::${bucket_name}"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${account_id}:root"
            },
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::${bucket_name}/*"
        }
    ]
}