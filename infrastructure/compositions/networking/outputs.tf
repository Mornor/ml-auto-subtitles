output "vpc_arn" {
  value = module.vpc.arn
}

output "vpc_id" {
  value = module.vpc.id
}

output "private_subnet_arn" {
  value = module.private_subnet.arn
}

output "private_subnet_id" {
  value = module.private_subnet.id
}