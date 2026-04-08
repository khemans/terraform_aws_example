variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "At least two subnets in different AZs."
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups that may connect to the database (e.g. app, bastion)."
  default     = []
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Optional CIDRs for Postgres (e.g. VPC CIDR for internal workloads)."
  default     = []
}

variable "database_name" {
  type    = string
  default = "appdb"
}

variable "master_username" {
  type    = string
  default = "dbadmin"
}

variable "engine_version" {
  type    = string
  default = "15.4"
}

variable "serverlessv2_min_capacity" {
  type    = number
  default = 0.5
}

variable "serverlessv2_max_capacity" {
  type    = number
  default = 1
}

variable "database_port" {
  type    = number
  default = 5432
  description = "The port on which the database accepts connections."
}

variable "tags" {
  type    = map(string)
  default = {}
}
