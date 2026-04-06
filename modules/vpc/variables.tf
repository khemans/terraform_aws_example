variable "project_name" {
  type        = string
  description = "Short name used in resource naming."
}

variable "environment" {
  type        = string
  description = "Environment label (e.g. dev, prod)."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "Exactly two AZ names for public/private subnet pairs."
}

variable "tags" {
  type        = map(string)
  description = "Extra tags merged onto all resources."
  default     = {}
}
