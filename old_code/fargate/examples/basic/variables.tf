variable "project_name" {
  type        = string
  description = "Name of the current project"
}

variable "environment" {
  type        = string
  description = "Current environment for deployment (ie qa, staging, prod)"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_region" {
  type        = string
  description = "AWS region (alias for region)"
  default     = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "Name tag of the VPC to use"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for subnets"
  default     = ["a", "b", "c"]
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
  default     = 80
}

variable "container_tag" {
  type        = string
  description = "Container image tag"
  default     = "latest"
}

variable "image" {
  type = object({
    repository = string
    tag        = string
  })
  description = "Container image configuration (alternative to container_tag)"
  default = {
    repository = ""
    tag        = "latest"
  }
}

variable "fargate_cpu" {
  type        = number
  description = "Fargate CPU units (1024 = 1 vCPU)"
  default     = 256
}

variable "fargate_memory" {
  type        = number
  description = "Fargate memory in MiB"
  default     = 512
}

variable "desired_count" {
  type        = number
  description = "Desired number of tasks"
  default     = 1
}

variable "health_check_path" {
  type        = string
  description = "Health check path"
  default     = "/"
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention in days"
  default     = 30
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable auto scaling"
  default     = false
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of tasks for autoscaling"
  default     = 1
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of tasks for autoscaling"
  default     = 10
}

variable "container_environment" {
  type        = list(map(string))
  description = "Environment variables for the container"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Reusable tags"
  default     = {}
}

variable "kubernetes_remote_state_bucket" {
  type        = string
  description = "Name of S3 bucket containing state of target infrastructure (for VPC remote state)"
  default     = ""
}

variable "kubernetes_remote_state_workspace" {
  type        = string
  description = "Workspace for remote state"
  default     = "nonprod"
}

