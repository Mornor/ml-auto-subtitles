variable "region" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "force_destroy" {
  type = bool
}

variable "versioning_enabled" {
  type = bool
}

variable "versioning_mfa_delete" {
  type = bool
}

variable "sse_algorithm" {
  type = string
}

variable "acl" {
  type = string
}

variable "block_public_policy" {
  type = bool
}

variable "block_public_acls" {
  type = bool
}

variable "ignore_public_acls" {
  type = bool
}

variable "restrict_public_buckets" {
  type = bool
}

variable "dynamodb_name" {
  type = string
}

variable "read_capacity" {
  type = number
}

variable "write_capacity" {
  type = number
}

variable "hash_key" {
  type = string
}

variable "sse_enabled" {
  type = bool
}

variable "attribute" {
  type = list(map(string))
}
