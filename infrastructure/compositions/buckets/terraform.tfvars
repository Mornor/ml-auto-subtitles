# Provider
region = "eu-central-1"

# App Bucket
app_bucket_name         = "s3-ec1-app-bucket"
app_bucket_policy_path  = "../../policies/private_bucket_policy.json.tpl"
force_destroy           = false
versioning_enabled      = false
versioning_mfa_delete   = false
sse_algorithm           = "AES256"
acl                     = "private"
block_public_policy     = true
block_public_acls       = true
ignore_public_acls      = true
restrict_public_buckets = true
keys                    = ["inputs/", "tmp/", "outputs/"]

# Lambdas Bucket
lambdas_bucket_name     = "s3-ec1-lambdas-bucket"
