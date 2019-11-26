# Create a Terraform backend.
# Encrypted S3 Bucket for the state files, DynamoDB Table to handle Terraform lock.

# Encrypted S3 Bucket
module "s3" {
  source                    = "../../resources/storage/s3"
  bucket_name               = var.bucket_name
  region                    = var.region
  acl                       = var.acl
  force_destroy             = var.force_destroy
  versioning_enabled        = var.versioning_enabled
  versioning_mfa_delete     = var.versioning_mfa_delete
  sse_algorithm             = var.sse_algorithm
  tags                      = local.s3_state_backend_tags
  policy                    = data.aws_iam_policy_document.bucket_policy.json
  block_public_policy       = var.block_public_policy
  block_public_acls         = var.block_public_acls
  ignore_public_acls        = var.ignore_public_acls
  restrict_public_buckets   = var.restrict_public_buckets
  keys                      = [""]
}

# DynamoDB
module "dynamodb" {
  source         = "../../resources/database/dynamodb"
  name           = var.dynamodb_name
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key
  attribute      = var.attribute
  sse_enabled    = var.sse_enabled
  tags           = local.ddb_state_backend_tags
}