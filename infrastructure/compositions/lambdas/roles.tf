# WIP - Will be teared appart some time in the future

# Extract sound Lambda, need to access the app_bucket
data "template_file" "extract_sound" {
  template = file(var.lambda_extract_sound_policy_path)
  vars = {
    app_bucket_arn = data.terraform_remote_state.app_bucket.outputs.bucket_arn
  }
}

module "lambda_extract_sound_role" {
  source             = "../../resources/iam/role"
  role_name          = var.lambda_extract_sound_name
  assume_role_policy = file(var.lambda_trust_policy)
}

module "lambda_extract_sound_policy" {
  source           = "../../resources/iam/policy"
  policy_name      = var.lambda_extract_sound_policy_name
  policy_statement = data.template_file.extract_sound.rendered
}

module "lambda_extract_sound_policy_attachment" {
  source     = "../../resources/iam/policy_attachment"
  role_name  = module.lambda_extract_sound_role.name
  policy_arn = module.lambda_extract_sound_policy.arn
}