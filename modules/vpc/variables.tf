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
  description = "List of AZ names for subnets."
}

variable "public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "Map of public subnet configurations. Key is subnet name, value contains CIDR and AZ."
  default     = {}
}

variable "private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "Map of private subnet configurations. Key is subnet name, value contains CIDR and AZ."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Extra tags merged onto all resources."
  default     = {}
}
