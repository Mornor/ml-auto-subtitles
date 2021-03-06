variable "region" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_tags" {
  type = map
}

variable "public_subnet_cidr_block" {
  type = string
}

variable "public_subnet_tags" {
  type = map
}

variable "public_subnet_assign_public_ip" {
  type = bool
}

variable "private_subnet_cidr_block" {
  type = string
}

variable "private_subnet_tags" {
  type = map
}

variable "private_subnet_assign_public_ip" {
  type = bool
}
