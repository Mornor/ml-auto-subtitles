# Backend S3 Bucket vars
region                  = "eu-central-1"
bucket_name             = "s3-ec1-subtitles-bucket"
force_destroy           = false
versioning_enabled      = false
versioning_mfa_delete   = false
sse_algorithm           = "AES256"
acl                     = "private"
block_public_policy     = true
block_public_acls       = true
ignore_public_acls      = true
restrict_public_buckets = true

# DynamoDB Lock table vars
dynamodb_name             = "dynamo-ec1-subtitles-terraform-lock"
read_capacity           = 2
write_capacity          = 2
hash_key                = "LockID"
sse_enabled             = true
attribute = [{
  name = "LockID"
  type = "S"
}]