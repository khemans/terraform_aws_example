variable "target_group_name" {
  type        = string
  description = "Name of the target group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the target group"
}

variable "port" {
  type        = number
  description = "Port for the target group"
  default     = 80
}

variable "protocol" {
  type        = string
  description = "Protocol for the target group"
  default     = "HTTP"
}

variable "target_type" {
  type        = string
  description = "Type of target (ip or instance)"
  default     = "ip"
}

variable "health_check_path" {
  type        = string
  description = "Health check path"
  default     = "/"
}

variable "health_check_healthy_threshold" {
  type        = number
  description = "Healthy threshold for health checks"
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  type        = number
  description = "Unhealthy threshold for health checks"
  default     = 2
}

variable "health_check_timeout" {
  type        = number
  description = "Health check timeout"
  default     = 5
}

variable "health_check_interval" {
  type        = number
  description = "Health check interval"
  default     = 30
}

variable "health_check_matcher" {
  type        = string
  description = "HTTP codes to consider healthy"
  default     = "200"
}

variable "deregistration_delay" {
  type        = number
  description = "Deregistration delay in seconds"
  default     = 300
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the target group"
  default     = {}
}

