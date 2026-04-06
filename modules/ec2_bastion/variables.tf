variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type        = string
  description = "Public subnet for the bastion (must have route to IGW)."
}

variable "ssh_ingress_cidr" {
  type        = string
  description = "CIDR allowed to SSH to the bastion (e.g. your office IP /32)."
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Optional EC2 Key Pair name in the account for SSH."
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
