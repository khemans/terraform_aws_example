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

variable "public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "Map of public subnet configurations."
  default     = {}
}

variable "private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "Map of private subnet configurations."
  default     = {}
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
