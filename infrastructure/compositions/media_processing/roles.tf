# WIP - Will be teared appart some time in the future

# Lambda to put file path into SQS when a file has been uploaded into /inputs from S3
data "template_file" "input_to_sqs_policy_template" {
  template = file(var.lambda_input_to_sqs_policy_path)
  vars = {
    app_bucket_arn = data.terraform_remote_state.app_bucket.outputs.bucket_arn
    sqs_arn        = module.sqs_inputs.arn
  }
}

module "lambda_input_to_sqs_role" {
  source             = "../../resources/iam/role"
  role_name          = var.lambda_input_to_sqs_name
  assume_role_policy = file(var.lambda_trust_policy)
}

module "lambda_input_to_sqs_policy" {
  source           = "../../resources/iam/policy"
  policy_name      = var.lambda_input_to_sqs_policy_name
  policy_statement = data.template_file.input_to_sqs_policy_template.rendered
}

module "lambda_input_to_sqs_policy_attachment" {
  source     = "../../resources/iam/policy_attachment"
  role_name  = module.lambda_input_to_sqs_role.name
  policy_arn = module.lambda_input_to_sqs_policy.arn
}

# ECS task role
module "ecs_task_role" {
  source             = "../../resources/iam/role"
  role_name          = var.ecs_task_role_name
  assume_role_policy = file(var.ecs_trust_policy)
}

module "ecs_task_role_policy_attachment" {
  source     = "../../resources/iam/policy_attachment"
  role_name  = var.ecs_task_role_name
  policy_arn = module.ecs_task_execution_policy.arn
}

# ECS Task Execution role
# TODO - Might need to remove the may be useless ecs_task_execution_role
data "template_file" "ecs_task_execution_policy_template" {
  template = file(var.ecs_task_execution_policy_path)
  vars = {
    app_bucket_arn = data.terraform_remote_state.app_bucket.outputs.bucket_arn
    sqs_arn = module.sqs_inputs.arn
  }
}

module "ecs_task_execution_policy" {
  source           = "../../resources/iam/policy"
  policy_name      = var.ecs_task_execution_policy_name
  policy_statement = data.template_file.ecs_task_execution_policy_template.rendered
}

module "ecs_task_execution_role" {
  source             = "../../resources/iam/role"
  role_name          = var.ecs_task_execution_role_name
  assume_role_policy = file(var.ecs_trust_policy)
}

module "ecs_task_execution_role_policy_attachment" {
  source     = "../../resources/iam/policy_attachment"
  role_name  = module.ecs_task_execution_role.name
  policy_arn = module.ecs_task_execution_policy.arn
}

# Lambda role to be able to launch an ECS task
data "template_file" "trigger_ecs_task_policy_template" {
  template = file(var.lambda_trigger_ecs_task_policy_path)
  vars = {
    ecs_cluster_arn     = module.ecs_cluster.arn
    task_definition_arn = module.ecs_task_definition.arn
  }
}

module "lambda_trigger_ecs_task_role" {
  source             = "../../resources/iam/role"
  role_name          = var.lambda_trigger_ecs_task_name
  assume_role_policy = file(var.lambda_trust_policy)
}

module "lambda_trigger_ecs_task_policy" {
  source           = "../../resources/iam/policy"
  policy_name      = var.lambda_trigger_ecs_task_policy_name
  policy_statement = data.template_file.trigger_ecs_task_policy_template.rendered
}

module "lambda_trigger_ecs_task_policy_attachment" {
  source     = "../../resources/iam/policy_attachment"
  role_name  = module.lambda_trigger_ecs_task_role.name
  policy_arn = module.lambda_trigger_ecs_task_policy.arn
}
