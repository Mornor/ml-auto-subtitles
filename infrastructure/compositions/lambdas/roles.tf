# WIP - Will be teared appart some time in the future

# Extract sound Lambda
data "template_file" "extract_sound" {
  template = file(var.)
  vars = {

  }
}

module "lambda_api_role" {
  source             = "../../../modules/iam/role"
  role_name          = local.lambda_api_role_name
  assume_role_policy = file(var.lambda_trust_policy)
}

module "lambda_api_role_policy" {
  source           = "../../../modules/iam/policy"
  policy_name      =
  policy_statement = data.template_file.extract_sound.rendered
}

module "lambda_api_role_policy_attachment" {
  source     = "../../../modules/iam/policy_attachment"
  role_name  =
  policy_arn =
}