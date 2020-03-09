resource "aws_vpc_endpoint" "this" {
  vpc_id        = var.vpc_id
  service_name  = var.service_name
  tags          = var.tags
}

resource "aws_vpc_endpoint_route_table_association" "this" {
  route_table_id  = var.rt_id
  vpc_endpoint_id = aws_vpc_endpoint.this.id
}