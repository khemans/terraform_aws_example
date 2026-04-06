variable "service_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "task_definition_arn" {
  type        = string
  description = "ARN of the task definition"
}

variable "desired_count" {
  type        = number
  description = "Number of tasks to run"
  default     = 1
}

variable "deployment_controller_type" {
  type        = string
  description = "Type of deployment controller (ECS or CODE_DEPLOY)"
  default     = "ECS"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs for the service"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the service"
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign public IP to tasks"
  default     = false
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the target group for load balancer"
  default     = ""
}

variable "container_name" {
  type        = string
  description = "Name of the container for load balancer target"
  default     = ""
}

variable "container_port" {
  type        = number
  description = "Port of the container for load balancer target"
  default     = 80
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the service"
  default     = {}
}

