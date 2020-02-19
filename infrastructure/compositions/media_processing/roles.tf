# WIP - Will be teared appart some time in the future

# Lambda to put file path into SQS when a file has been uploaded into /inputs from S3
data "template_file" "input_to_sqs_policy_template" {
  template = file(var.lambda_input_to_sqs_policy_path)
  vars = {
    app_bucket_arn = data.terraform_remote_state.buckets.outputs.app_bucket_arn
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
    app_bucket_arn = data.terraform_remote_state.buckets.outputs.app_bucket_arn
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
    sqs_arn                     = module.sqs_inputs.arn
    region                      = var.region
    account_id                  = data.aws_caller_identity.current.account_id
    ecs_cluster_arn             = module.ecs_cluster.arn
    ecs_task_execution_role_arn = module.ecs_task_execution_role.arn
    ecs_task_role_arn           = module.ecs_task_role.arn
    task_definition_name        = var.ecs_task_name
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

# Lambda role to be able to trigger Transcribe job
data "template_file" "trigger_transcribe_job_policy_template" {
  template = file(var.lambda_trigger_transcribe_job_policy_path)
  vars = {
    app_bucket_arn        = data.terraform_remote_state.buckets.outputs.app_bucket_arn
    transcribe_bucket_arn = data.terraform_remote_state.buckets.outputs.transcribe_result_bucket_arn
  }
}

module "lambda_trigger_transcribe_job_role" {
  source             = "../../resources/iam/role"
  role_name          = var.lambda_trigger_transcribe_job_name
  assume_role_policy = file(var.lambda_trust_policy)
}

module "lambda_trigger_transcribe_job_policy" {
  source           = "../../resources/iam/policy"
  policy_name      = var.lambda_trigger_transcribe_job_policy_name
  policy_statement = data.template_file.trigger_transcribe_job_policy_template.rendered
}

module "lambda_trigger_transcribe_job_policy_attachment" {
  source     = "../../resources/iam/policy_attachment"
  role_name  = module.lambda_trigger_transcribe_job_role.name
  policy_arn = module.lambda_trigger_transcribe_job_policy.arn
}

# Lambda role to be able to parse the result of the Transcribe job
data "template_file" "lambda_parse_transcribe_result_policy_template" {
  template = file(var.lambda_parse_transcribe_result_policy_path)
  vars = {
    app_bucket_arn    = data.terraform_remote_state.buckets.outputs.app_bucket_arn
    result_bucket_arn = data.terraform_remote_state.buckets.outputs.transcribe_result_bucket_arn
  }
}

module "lambda_parse_transcribe_result_role" {
  source             = "../../resources/iam/role"
  role_name          = var.lambda_parse_transcribe_result_name
  assume_role_policy = file(var.lambda_trust_policy)
}

module "lambda_parse_transcribe_result_policy" {
  source           = "../../resources/iam/policy"
  policy_name      = var.lambda_parse_transcribe_result_policy_name
  policy_statement = data.template_file.lambda_parse_transcribe_result_policy_template.rendered
}

module "lambda_parse_transcribe_result_policy_attachment" {
  source     = "../../resources/iam/policy_attachment"
  role_name  = module.lambda_parse_transcribe_result_role.name
  policy_arn = module.lambda_parse_transcribe_result_policy.arn
}
