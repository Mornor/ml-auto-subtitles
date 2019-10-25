resource "aws_dynamodb_table" "this" {
  name           = var.name
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key

  dynamic "attribute" {
    for_each = var.attribute
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  server_side_encryption {
    enabled = var.sse_enabled
  }

  tags = var.tags
}