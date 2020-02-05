resource "aws_subnet" "this" {
  vpc_id     = var.vpc_id
  cidr_block = var.private_subnet_cidr_block
  tags       = var.private_subnet_tags
}