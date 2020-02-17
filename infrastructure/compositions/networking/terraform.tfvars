# General attributes
region = "eu-central-1"

# VPC
vpc_cidr_block = "10.0.0.0/16"
vpc_tags = {
  Name = "Main VPC"
}

# Public Subnet
public_subnet_cidr_block = "10.0.0.0/20"
public_subnet_assign_public_ip = true
public_subnet_tags = {
  Name = "Public Subnet"
}

# Private Subnet
private_subnet_cidr_block = "10.0.16.0/20"
private_subnet_assign_public_ip = false
private_subnet_tags = {
  Name = "Private Subnet"
}