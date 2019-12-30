terraform {
  required_version = ">= 0.12"
   backend "s3" {
   }
}

provider "aws" {
  version                 = "~> 2.4"
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "cloudreach-lab"
}