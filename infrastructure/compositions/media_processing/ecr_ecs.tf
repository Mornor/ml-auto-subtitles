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
module "ecs_cluster" {
  source = "../../resources/container/ecs/cluster"
  name = var.ecs_cluster_name
}

# ECS Task definitiom
module "ecs_task" {
  source                  = "../../resources/container/ecs/task_definition"
  ecs_task_name           = var.ecs_task_name
  ecs_type                = var.ecs_type
  ecs_cpu                 = var.ecs_cpu
  ecs_mem                 = var.ecs_mem
  network_mode            = var.ecs_network_mode
  ecs_task_definition     = data.template_file.ecs_task_definition.rendered
  ecs_task_role_arn       = module.ecs_task_role.arn
  ecs_execution_role_arn  = module.ecs_task_execution_role.arn
}
