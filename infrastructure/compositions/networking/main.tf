# Main VPC
module "vpc" {
  source         = "../../resources/networking/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  vpc_tags       = var.vpc_tags
}

# Public subnet
module "public_subnet" {
  source            = "../../resources/networking/subnet"
  vpc_id            = module.vpc.id
  subnet_cidr_block = var.public_subnet_cidr_block
  subnet_tags       = var.public_subnet_tags
  assign_public     = var.public_subnet_assign_public_ip
}

# Private subnet
module "private_subnet" {
  source            = "../../resources/networking/subnet"
  vpc_id            = module.vpc.id
  subnet_cidr_block = var.private_subnet_cidr_block
  subnet_tags       = var.private_subnet_tags
  assign_public     = var.private_subnet_assign_public_ip
}

# Internet connectivity and NAT gateway
module "connectivity" {
  source            = "../../resources/networking/connectivity"
  vpc_id            = module.vpc.id
  vpc_main_rt       = module.vpc.main_route_table
  private_subnet_id = module.private_subnet.id
  public_subnet_id  = module.public_subnet.id
}

# Create a RT for the Private subnet

# Create a VPC endpoint for S3 and associate the route table of the S3 endpoints
module "s3_endpoint" {
  source        = "../../resources/networking/vpc_endpoints/s3_endpoint"
  vpc_id        = module.vpc.id
  service_name  = "com.amazonaws.${var.region}.s3"
  rt_id         = module.connectivity.private_subnet_rt_id
  tags          = local.s3_endpoint_tags
}