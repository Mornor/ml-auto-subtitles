module "upload_lambda" {
  source             = "../../resources/lambdas/upload"
  lambda_path_input  = var.lambda_extract_sound_input_path
  lambda_path_output = var.lambda_extract_sound_output_path
  bucket_name        = data.terraform_remote_state.lambda_bucket.outputs.bucket_name
  lambda_s3_key      = var.lambda_extract_sound_s3_key
  lambda_name        = var.lambda_extract_sound_name
  handler            = var.lambda_extract_sound_handler
  description        = var.lambda_extract_sound_description
  runtime            = var.runtime
  memory_size        = var.memory_size
  timeout            = var.timeout
  publish            = var.publish
  role_arn           = module.lambda_extract_sound_role.arn
  tags               = local.lambda_extract_sound_tags
}