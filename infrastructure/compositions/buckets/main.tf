# Hold the audio file to be transcribed
module "app_bucket" {
  source                  = "../../resources/storage/s3"
  bucket_name             = var.app_bucket_name
  region                  = var.region
  acl                     = var.acl
  force_destroy           = var.force_destroy
  versioning_enabled      = var.versioning_enabled
  versioning_mfa_delete   = var.versioning_mfa_delete
  sse_algorithm           = var.sse_algorithm
  tags                    = local.s3_app_bucket_tags
  policy_path             = var.app_bucket_policy_path
  account_id              = data.aws_caller_identity.current.account_id
  block_public_policy     = var.block_public_policy
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
  keys                    = var.keys
}

# Hold the AWS Lambdas function of the project
module "lambdas_bucket" {
  source                  = "../../resources/storage/s3"
  bucket_name             = var.lambdas_bucket_name
  region                  = var.region
  acl                     = var.acl
  force_destroy           = var.force_destroy
  versioning_enabled      = var.versioning_enabled
  versioning_mfa_delete   = var.versioning_mfa_delete
  sse_algorithm           = var.sse_algorithm
  tags                    = local.s3_app_lambdas_bucket_tags
  block_public_policy     = var.block_public_policy
  block_public_acls       = var.block_public_acls
  policy_path             = var.app_bucket_policy_path
  account_id              = data.aws_caller_identity.current.account_id
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
  keys                    = []
}