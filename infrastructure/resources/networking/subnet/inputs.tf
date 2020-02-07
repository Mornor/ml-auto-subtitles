variable "vpc_id" {
  type = string
}

variable "subnet_cidr_block" {
  type = string
}

variable "subnet_tags" {
  type = map
}

variable "assign_public" {
  type = bool
}