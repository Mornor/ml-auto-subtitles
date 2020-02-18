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
  lambda_trigger_ecs_task_tags = {
    Name = var.lambda_trigger_ecs_task_name
  }
  lambda_trigger_ecs_task_env_variables = {
    cluster_name         = var.ecs_cluster_name
    subnet_id            = data.terraform_remote_state.networking.outputs.private_subnet_id
    task_definition_name = var.ecs_task_name
    container_name       = var.ecs_container_name
  }
  lambda_trigger_transcribe_job_tags = {
    Name = var.lambda_trigger_transcribe_job_name
  }
  lambda_trigger_transcribe_job_env_variables = {
    region        = var.region
    result_bucket = data.terraform_remote_state.buckets.outputs.transcribe_result_bucket_name
  }
}