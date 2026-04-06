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
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "ssh_ingress_cidr" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
