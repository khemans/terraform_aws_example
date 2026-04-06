variable "family" {
  type        = string
  description = "Family name for the task definition"
}

variable "execution_role_arn" {
  type        = string
  description = "ARN of the execution role"
}

variable "task_role_arn" {
  type        = string
  description = "ARN of the task role"
  default     = ""
}

variable "cpu" {
  type        = number
  description = "CPU units for the task (1024 = 1 vCPU)"
}

variable "memory" {
  type        = number
  description = "Memory for the task in MiB"
}

variable "container_definitions" {
  type        = string
  description = "JSON string of container definitions"
}

variable "network_mode" {
  type        = string
  description = "Network mode for the task"
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  type        = list(string)
  description = "Launch types required"
  default     = ["FARGATE"]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the task definition"
  default     = {}
}

