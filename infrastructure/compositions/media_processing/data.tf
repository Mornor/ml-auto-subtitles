# Remote state
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

locals {
  sqs_tags = {
    Name = var.sqs_name
  }
  lambda_input_to_sqs_tags = {
    Name = var.lambda_input_to_sqs_name
  }
  lambda_input_to_sqs_env_variables = {
    queue_url = module.sqs_inputs.url
  }
}