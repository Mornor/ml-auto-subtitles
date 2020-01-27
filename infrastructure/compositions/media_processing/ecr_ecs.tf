# Create an ECR to store image used to extract sound.
module "ecr" {
  source  = "../../resources/container/ecr"
  name    = var.ecr_name
}

# ECS is
// - Container definition
// - Task definition
// - Service
// - Cluster

# ECS Cluster
module "ecs" {
  source                  = "../../resources/container/ecs"
  ecs_task_name           = var.ecs_task_name
  ecs_type                = var.ecs_type
  ecs_cpu                 = var.ecs_cpu
  ecs_mem                 = var.ecs_mem
  ecs_task_definition     = file(data.template_file.ecs_task_definition.rendered)
  ecs_task_role_arn       = module.ecs_task_role.arn
  ecs_execution_role_arn  = var.ecs_execution_role_arn
}
