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
  type        = list(string)
  description = "Two AZs in the target region."
}

variable "extra_tags" {
  type    = map(string)
  default = {}
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
