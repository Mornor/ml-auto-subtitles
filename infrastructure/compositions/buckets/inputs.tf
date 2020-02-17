variable "region" {
  type = string
}

variable "app_bucket_name" {
  type = string
}

variable "lambdas_bucket_name" {
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

variable "app_bucket_policy_path" {
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

variable "keys" {
  type = list
}