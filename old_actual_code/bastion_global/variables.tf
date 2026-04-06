variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3a.micro"
}

variable "subnet_id" {
  description = "Subnet ID for the bastion host"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}

variable "key_name" {
  description = "Key Pair used for ec2_instance."
  type = string
}

variable "vpc_id" {
  
}

variable "environment" {
  
}