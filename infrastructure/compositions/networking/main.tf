# Main VPC
module "vpc" {
  source         = "../../resources/networking/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  vpc_tags       = var.vpc_tags
}

# Private subnet
module "private_subnet" {
  source                    = "../../resources/networking/subnet"
  vpc_id                    = module.vpc.id
  private_subnet_cidr_block = var.private_subnet_cidr_block
  private_subnet_tags       = var.private_subnet_tags
}

# Internet connectivity and NAT gateway
module "connectivity" {
  source            = "../../resources/networking/connectivity"
  vpc_id            = module.vpc.id
  vpc_main_rt       = module.vpc.main_route_table
  private_subnet_id = module.private_subnet.id
}