variable "alb_name" {
  type        = string
  description = "Name of the Application Load Balancer"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the load balancer"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs for the load balancer"
}

variable "internal" {
  type        = bool
  description = "Whether the load balancer is internal"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the load balancer"
  default     = {}
}

