# Trigger the Lambda when a message is received on the SQS Queue
resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn = var.sqs_queue_arn
  function_name    = var.lambda_arn
  enabled          = true
}