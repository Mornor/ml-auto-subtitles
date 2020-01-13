# When a input video is uploaded to S3 (/inputs), a Lambda is triggered and populate this SQS with the S3 path of the input.
module "sqs_inputs" {
  source  = "../../resources/buffer/sqs"
  name                       = var.sqs_name
  message_retention_seconds  = var.sqs_message_retention_seconds
  tags                       = local.sqs_tags
}
