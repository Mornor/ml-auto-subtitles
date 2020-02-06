# IGW
resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id
}

# Route the public subnet traffic through the IGW
# TODO - Not sure this is useful though.
resource "aws_route" "internet_access" {
  route_table_id         = var.vpc_main_rt
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Create a NAT gateway with an EIP for each private subnet to get internet connectivity - allowing Docker images to be pulled from a private subnet
resource "aws_eip" "this" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  subnet_id     = var.private_subnet_id
  allocation_id = aws_eip.this.id
}

# Route table for the private subnets
# And make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

# Explicitely associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "this" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.this.id
}