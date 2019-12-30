# Upload all the lambdas from local to S3
data "archive_file" "zipit" {
  type        = "zip"
  source_file = var.lambda_path_input
  output_path = var.lambda_path_output
}

resource "aws_s3_bucket_object" "this" {
  bucket = var.bucket_name
  key    = var.lambda_s3_key
  source = data.archive_file.zipit.output_path
}

resource "aws_lambda_function" "this" {
  function_name    = var.lambda_name
  description      = var.description
  s3_bucket        = var.bucket_name
  s3_key           = aws_s3_bucket_object.this.key
  handler          = var.handler
  //source_code_hash = base64sha256(data.archive_file.zipit.output_path)
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  role             = var.role_arn
  publish          = var.publish
  tags             = var.tags


  // vpc_config {
  //   subnet_ids         = var.subnet_ids
  //   security_group_ids = var.security_group_ids
  // }
}

# Allow Lambda to be invoked from S3
resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.app_bucket_arn
}

resource "aws_s3_bucket_notification" "this" {
  bucket = var.app_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.s3_event_filter_prefix
  }
}