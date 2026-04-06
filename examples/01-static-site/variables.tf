variable "aws_region" {
  type        = string
  description = "AWS region (agnostic — set per workspace or tfvars)."
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
