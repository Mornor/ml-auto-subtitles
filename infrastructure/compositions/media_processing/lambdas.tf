module "lamda_input_to_sqs" {
  source                 = "../../resources/lambdas/upload"
  lambda_path_input      = var.lambda_input_to_sqs_input_path
  lambda_path_output     = var.lambda_input_to_sqs_output_path
  bucket_name            = data.terraform_remote_state.lambda_bucket.outputs.bucket_name
  app_bucket_id          = data.terraform_remote_state.app_bucket.outputs.bucket_id
  app_bucket_arn         = data.terraform_remote_state.app_bucket.outputs.bucket_arn
  lambda_s3_key          = var.lambda_input_to_sqs_s3_key
  lambda_name            = var.lambda_input_to_sqs_name
  handler                = var.lambda_input_to_sqs_handler
  description            = var.lambda_input_to_sqs_description
  s3_event_filter_prefix = var.lambda_input_to_sqs_s3_event_filter_prefix
  runtime                = var.runtime
  memory_size            = var.memory_size
  timeout                = var.timeout
  publish                = var.publish
  role_arn               = module.lambda_input_to_sqs_role.arn
  environment_variables  = local.lambda_input_to_sqs_env_variables
  triggered_by           = var.lambda_input_to_sqs_triggered_by
  tags                   = local.lambda_input_to_sqs_tags
}

module "lambda_trigger_ecs_task" {
  source                 = "../../resources/lambdas/upload"
  lambda_path_input      = var.lambda_trigger_ecs_task_input_path
  lambda_path_output     = var.lambda_trigger_ecs_task_output_path
  bucket_name            = data.terraform_remote_state.lambda_bucket.outputs.bucket_name
  lambda_s3_key          = var.lambda_trigger_ecs_task_s3_key
  lambda_name            = var.lambda_trigger_ecs_task_name
  handler                = var.lambda_trigger_ecs_task_handler
  description            = var.lambda_trigger_ecs_task_description
  runtime                = var.runtime
  memory_size            = var.memory_size
  timeout                = var.timeout
  publish                = var.publish
  role_arn               = module.lambda_trigger_ecs_task_role.arn
  environment_variables  = local.lambda_trigger_ecs_task_env_variables
  triggered_by           = var.lambda_trigger_ecs_task_triggered_by
  tags                   = local.lambda_trigger_ecs_task_tags
}