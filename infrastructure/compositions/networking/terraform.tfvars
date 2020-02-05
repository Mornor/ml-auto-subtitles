# General attributes
region = "eu-central-1"

# VPC
vpc_cidr_block = "10.0.0.0/16"
vpc_tags = {
  Name = "Main VPC"
}

# Private Subnet
private_subnet_cidr_block = "10.0.0.0/24"
private_subnet_tags = {
  Name = "Private Subnet"
}