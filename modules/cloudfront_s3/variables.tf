variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "s3_bucket_id" {
  type        = string
  description = "S3 bucket name (id)."
}

variable "s3_bucket_arn" {
  type        = string
  description = "S3 bucket ARN for bucket policy."
}

variable "s3_bucket_regional_domain_name" {
  type        = string
  description = "Regional domain name for the S3 origin (see aws_s3_bucket bucket_regional_domain_name)."
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "min_ttl" {
  type    = number
  default = 0
  description = "Minimum time to live for objects in cache."
}

variable "default_ttl" {
  type    = number
  default = 3600
  description = "Default time to live for objects in cache (in seconds)."
}

variable "max_ttl" {
  type    = number
  default = 86400
  description = "Maximum time to live for objects in cache (in seconds)."
}

variable "compress" {
  type    = bool
  default = true
  description = "Whether CloudFront should automatically compress response bodies."
}

variable "tags" {
  type    = map(string)
  default = {}
}
