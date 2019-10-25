########################################
# AWS S3 Bucket resource module
#
# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
# https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html
# https://www.terraform.io/docs/providers/aws/r/s3_bucket_public_access_block.html
########################################

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  region        = var.region
  acl           = var.acl
  force_destroy = var.force_destroy

  versioning {
    enabled    = var.versioning_enabled ? true : false
    mfa_delete = var.versioning_mfa_delete ? true : false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = var.policy
}

# Fix the issue with aws_s3_bucket_public_access_block creation
resource "null_resource" "delay" {
  depends_on = [aws_s3_bucket.this]

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  depends_on = [null_resource.delay]
}