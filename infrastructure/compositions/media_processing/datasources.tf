# Current account ID
data "aws_caller_identity" "current" {}

# Remote states
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket  = "s3-ec1-subtitles-bucket-state-files"
    key     = "app/networking/terraform.tfstate"
    region  = "eu-central-1"
  }
}

data "terraform_remote_state" "lambda_bucket" {
  backend = "s3"

  config = {
    bucket = "s3-ec1-subtitles-bucket-state-files"
    key    = "app/lambdas_bucket/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "app_bucket" {
  backend = "s3"

  config = {
    bucket = "s3-ec1-subtitles-bucket-state-files"
    key    = "app/bucket/terraform.tfstate"
    region = var.region
  }
}