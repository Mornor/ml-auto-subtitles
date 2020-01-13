output "arn" {
  value = aws_sqs_queue.this.arn
}

output "url" {
  value = aws_sqs_queue.this.id
}