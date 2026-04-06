variable "service_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of tasks"
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of tasks"
}

variable "cpu_target_value" {
  type        = number
  description = "Target CPU utilization percentage"
  default     = 70
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to autoscaling resources"
  default     = {}
}

