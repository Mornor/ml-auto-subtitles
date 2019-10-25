variable "name" {
  type = string
}

variable "read_capacity" {
  type = string
}

variable "write_capacity" {
  type = string
}

variable "hash_key" {
  type = string
}

variable "attribute" {
  type = list
}

variable "sse_enabled" {
  type = string
}

variable "tags" {
  type = map
}
