variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "bucket_suffix" {
  type        = string
  description = "Globally unique suffix (e.g. account id or random)."
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "block_public_acls" {
  type    = bool
  default = true
  description = "Block public ACLs on this bucket."
}

variable "block_public_policy" {
  type    = bool
  default = true
  description = "Block public bucket policies on this bucket."
}

variable "ignore_public_acls" {
  type    = bool
  default = true
  description = "Ignore existing public ACLs on this bucket."
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
  description = "Restrict public access to this bucket."
}

variable "tags" {
  type    = map(string)
  default = {}
}
