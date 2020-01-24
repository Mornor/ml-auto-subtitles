# Create an ECR to store image used to extract sound.
module "ecr" {
  source  = "../../resources/container/ecr"
  name    = var.ecr_name
}

# ECS Cluster
module "ecs" {
  source                  = "../../resources/container/ecs"
  ecs_task_name           = var.ecs_task_name
  ecs_type                = var.ecs_type
  ecs_cpu                 = var.ecs_cpu
  ecs_mem                 = var.ecs_mem
  ecs_task_role_arn       = var.ecs_task_role_arn
  ecs_execution_role_arn  = var.ecs_execution_role_arn
}
