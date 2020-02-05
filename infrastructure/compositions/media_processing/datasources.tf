data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket  = "s3-ec1-subtitles-bucket-state-files"
    key     = "app/networking/terraform.tfstate"
    region  = "eu-central-1"
  }
}