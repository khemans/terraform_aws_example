variable "log_group_name" {
  type        = string
  description = "Name of the CloudWatch log group"
}

variable "retention_in_days" {
  type        = number
  description = "Number of days to retain logs"
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the log group"
  default     = {}
}

