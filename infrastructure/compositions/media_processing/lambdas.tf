# Lambda triggered when the inputs video file is uploaded into /inputs from the app-bucket.
module "lambda_input_to_sqs" {
  source                = "../../resources/lambdas/upload"
  lambda_path_input     = var.lambda_input_to_sqs_input_path
  lambda_path_output    = var.lambda_input_to_sqs_output_path
  bucket_name           = data.terraform_remote_state.buckets.outputs.lambdas_bucket_name
  bucket_arn            = data.terraform_remote_state.buckets.outputs.app_bucket_arn
  lambda_s3_key         = var.lambda_input_to_sqs_s3_key
  lambda_name           = var.lambda_input_to_sqs_name
  handler               = var.lambda_input_to_sqs_handler
  description           = var.lambda_input_to_sqs_description
  runtime               = var.runtime
  memory_size           = var.memory_size
  timeout               = var.timeout
  publish               = var.publish
  role_arn              = module.lambda_input_to_sqs_role.arn
  environment_variables = local.lambda_input_to_sqs_env_variables
  subnet_ids            = [data.terraform_remote_state.networking.outputs.private_subnet_id]
  sg_ids                = [module.default_sg.id]
  tags                  = local.lambda_input_to_sqs_tags
}

# Lambda to trigger the ECS task (extracting the sound from the video under /inputs).
module "lambda_trigger_ecs_task" {
  source                = "../../resources/lambdas/upload"
  lambda_path_input     = var.lambda_trigger_ecs_task_input_path
  lambda_path_output    = var.lambda_trigger_ecs_task_output_path
  bucket_name           = data.terraform_remote_state.buckets.outputs.lambdas_bucket_name
  lambda_s3_key         = var.lambda_trigger_ecs_task_s3_key
  lambda_name           = var.lambda_trigger_ecs_task_name
  handler               = var.lambda_trigger_ecs_task_handler
  description           = var.lambda_trigger_ecs_task_description
  runtime               = var.runtime
  memory_size           = var.memory_size
  timeout               = var.timeout
  publish               = var.publish
  role_arn              = module.lambda_trigger_ecs_task_role.arn
  environment_variables = local.lambda_trigger_ecs_task_env_variables
  subnet_ids            = [data.terraform_remote_state.networking.outputs.private_subnet_id]
  sg_ids                = [module.default_sg.id]
  tags                  = local.lambda_trigger_ecs_task_tags
}

# Lambda to trigger the Transcribe job once the sound is extracted
module "lambda_transcribe_job" {
  source                = "../../resources/lambdas/upload"
  lambda_path_input     = var.lambda_trigger_transcribe_job_input_path
  lambda_path_output    = var.lambda_trigger_transcribe_job_output_path
  bucket_name           = data.terraform_remote_state.buckets.outputs.lambdas_bucket_name
  bucket_arn            = data.terraform_remote_state.buckets.outputs.app_bucket_arn
  lambda_s3_key         = var.lambda_trigger_transcribe_job_s3_key
  lambda_name           = var.lambda_trigger_transcribe_job_name
  handler               = var.lambda_trigger_transcribe_job_handler
  description           = var.lambda_trigger_transcribe_job_description
  runtime               = var.runtime
  memory_size           = var.memory_size
  timeout               = var.timeout
  publish               = var.publish
  role_arn              = module.lambda_trigger_transcribe_job_role.arn
  environment_variables = local.lambda_trigger_transcribe_job_env_variables
  subnet_ids            = [data.terraform_remote_state.networking.outputs.private_subnet_id]
  sg_ids                = [module.default_sg.id]
  tags                  = local.lambda_trigger_transcribe_job_tags
}

module "lambda_parse_transcribe_result" {
  source                = "../../resources/lambdas/upload"
  lambda_path_input     = var.lambda_parse_transcribe_result_input_path
  lambda_path_output    = var.lambda_parse_transcribe_result_output_path
  bucket_name           = data.terraform_remote_state.buckets.outputs.lambdas_bucket_name
  bucket_arn            = data.terraform_remote_state.buckets.outputs.transcribe_result_bucket_arn
  lambda_s3_key         = var.lambda_parse_transcribe_result_s3_key
  lambda_name           = var.lambda_parse_transcribe_result_name
  handler               = var.lambda_parse_transcribe_result_handler
  description           = var.lambda_parse_transcribe_result_description
  runtime               = var.runtime
  memory_size           = var.memory_size
  timeout               = var.timeout
  publish               = var.publish
  role_arn              = module.lambda_parse_transcribe_result_role.arn
  environment_variables = local.lambda_parse_transcribe_result_env_variables
  subnet_ids            = [data.terraform_remote_state.networking.outputs.private_subnet_id]
  sg_ids                = [module.default_sg.id]
  tags                  = local.lambda_parse_transcribe_result_tags
}

module "app_bucket_notifications" {
  source             = "../../resources/lambdas/bucket_notification"
  bucket_id          = data.terraform_remote_state.buckets.outputs.app_bucket_id
  lambdas_attributes = local.app_bucket_lambdas_attributes
}

module "transcribe_bucket_notification" {
  source             = "../../resources/lambdas/bucket_notification"
  bucket_id          = data.terraform_remote_state.buckets.outputs.transcribe_result_bucket_id
  lambdas_attributes = local.transcribe_result_bucket_lambdas_attributes
}

module "sqs_notification" {
  source        = "../../resources/lambdas/sqs_notification"
  sqs_queue_arn = module.sqs_inputs.arn
  lambda_arn    = module.lambda_trigger_ecs_task.arn
}

# CW Custom event
// {
//   "source": [
//     "aws.transcribe"
//   ],
//   "detail-type": [
//     "Transcribe Job State Change"
//   ],
//   "detail": {
//     "TranscriptionJobStatus": [
//       "COMPLETED"
//     ]
//   }
// }
