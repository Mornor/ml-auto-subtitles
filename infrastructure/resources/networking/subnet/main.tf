resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = var.assign_public
  tags                    = var.subnet_tags
}