variable "execution_role_name" {
  type        = string
  description = "Name of the execution role"
}

variable "task_role_name" {
  type        = string
  description = "Name of the task role"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to IAM resources"
  default     = {}
}

