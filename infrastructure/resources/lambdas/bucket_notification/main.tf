# Trigger the Lambda when an object is created under lambda_function.value.filter_prefix
resource "aws_s3_bucket_notification" "this" {
  bucket = var.bucket_id

  dynamic "lambda_function" {
    for_each = var.lambdas_attributes
    content {
      lambda_function_arn = lambda_function.value.arn
      events              = [lambda_function.value.events]
      filter_prefix       = lambda_function.value.filter_prefix
    }
  }
}