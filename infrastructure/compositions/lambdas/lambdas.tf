module "upload_lambda" {
  source             = "../../resources/lambdas/upload"
  lambda_path_input  = var.lambda_extract_sound_input_path
  lambda_path_output = var.lambda_extract_sound_output_path
  bucket_name        = data.terraform_remote_state.lambda_bucket.name
  lambda_s3_key      = var.lambda_extract_sound_s3_key
  lambda_name        = var.lambda_extract_sound_s3_name
  handler            = var.lambda_extract_sound_handler
  runtime            = var.lambda_extract_sound_runtime
  memory_size        = var.lambda_extract_sound_mem_size
  timeout            = var.lambda_extract_sound_timeout
  role_arn           = module.lambda_extract_sound_role.arn
  publish            = var.lambda_extract_sound_publish
  tags               = local.lambda_extract_sound_tags
}