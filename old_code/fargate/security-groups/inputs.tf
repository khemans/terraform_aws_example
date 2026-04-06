variable "vpc_id" {
  type        = string
  description = "VPC ID for security groups"
}

variable "lb_security_group_name" {
  type        = string
  description = "Name of the load balancer security group"
}

variable "ecs_security_group_name" {
  type        = string
  description = "Name of the ECS tasks security group"
}

variable "app_port" {
  type        = number
  description = "Port the application listens on"
}

variable "ingress_ports" {
  type        = list(number)
  description = "List of ports to allow ingress on the load balancer"
  default     = [80, 443]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to security groups"
  default     = {}
}

