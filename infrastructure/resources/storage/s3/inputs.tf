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

variable "tags" {
  type = map
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

variable "policy" {
  type = string
}

variable "keys" {
  type = list
}