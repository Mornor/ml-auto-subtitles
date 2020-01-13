# WIP - Will be teared appart some time in the future

# Lambda to put file path into SQS when a file has been uploaded into /inputs from S3
data "template_file" "input_to_sqs" {
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
  policy_statement = data.template_file.input_to_sqs.rendered
}

module "lambda_input_to_sqs_policy_attachment" {
  source     = "../../resources/iam/policy_attachment"
  role_name  = module.lambda_input_to_sqs_role.name
  policy_arn = module.lambda_input_to_sqs_policy.arn
}