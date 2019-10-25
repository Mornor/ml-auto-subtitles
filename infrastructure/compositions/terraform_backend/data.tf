# Current cccount ID
data "aws_caller_identity" "current" {}

# S3 Bucket Policy
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }
}

locals {
  s3_state_backend_tags = {
    Name  = "s3-state-bucket"
  }
  ddb_state_backend_tags = {
    Name  = "ddb-lock-table"
  }
}