resource "aws_sqs_queue" "this" {
  name                       = var.name
  message_retention_seconds  = var.message_retention_seconds
  tags                       = var.tags
}