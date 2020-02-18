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
  function_name = var.lambda_name
  description   = var.description
  s3_bucket     = var.bucket_name
  s3_key        = aws_s3_bucket_object.this.key
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout
  role          = var.role_arn
  publish       = var.publish
  tags          = var.tags

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [var.environment_variables] : []
    content {
      variables = environment.value
    }
  }

  // vpc_config {
  //   subnet_ids         = var.subnet_ids
  //   security_group_ids = var.security_group_ids
  // }
}

// # Allow Lambda to be invoked from S3
resource "aws_lambda_permission" "this" {
  count         = var.bucket_arn != "" ? 1 : 0
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}

# Create the Cloudwatch log groups associated to the Lambda
resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.lambda_name}"
}