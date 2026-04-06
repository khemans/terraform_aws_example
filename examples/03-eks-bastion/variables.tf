variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = list(string)
}

variable "ssh_ingress_cidr" {
  type        = string
  description = "Restrict in real use (e.g. x.x.x.x/32)."
  default     = "0.0.0.0/0"
}

variable "eks_cluster_version" {
  type    = string
  default = "1.29"
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
