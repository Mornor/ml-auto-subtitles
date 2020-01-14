# Create an ECR, and upload a Docker image in it with a local Dockerfile

module "ecr" {
  source  = "../../resources/container/ecr"
  name    = var.ecr_name
}