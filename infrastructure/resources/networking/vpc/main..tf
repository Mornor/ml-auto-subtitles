resource "aws_vpc" "this" {
  cidr_block              = var.vpc_cidr_block
  tags                    = var.vpc_tags
}