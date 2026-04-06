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

variable "enable_bastion" {
  type        = bool
  description = "Deploy the EC2 bastion host. Can be disabled in dev to save cost."
  default     = true
}

variable "enable_eks" {
  type        = bool
  description = "Deploy the EKS cluster. Can be disabled in dev to save cost."
  default     = true
}

variable "enable_aurora" {
  type        = bool
  description = "Deploy the Aurora RDS cluster. Can be disabled in dev to save cost."
  default     = true
}

variable "enable_redis" {
  type        = bool
  description = "Deploy the ElastiCache Redis cluster. Can be disabled in dev to save cost."
  default     = true
}
