# Lambdas Bucket
region                  = "eu-central-1"
bucket_name             = "s3-ec1-lambdas-bucket"
force_destroy           = false
versioning_enabled      = false
versioning_mfa_delete   = false
sse_algorithm           = "AES256"
acl                     = "private"
block_public_policy     = true
block_public_acls       = true
ignore_public_acls      = true
restrict_public_buckets = true
keys                    = ["extract_sound/", "transcribe_job/", "on_transcibe_done/"]

# extract_sound -> moviepym extract sound from video file
# transcribe_job -> launch Transcibe job
# on_transcibe_done -> Parse transcribe results and uplaod to /outputs in S3