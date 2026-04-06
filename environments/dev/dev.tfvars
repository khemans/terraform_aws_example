aws_region   = "us-east-1"
project_name = "interview-platform"
environment  = "dev"

vpc_cidr = "10.100.0.0/16"

availability_zones = ["us-east-1a", "us-east-1b"]

ssh_ingress_cidr = "0.0.0.0/0"

eks_cluster_version = "1.29"

# Disable expensive services in dev to reduce cost
enable_bastion = false
enable_eks     = false
enable_aurora  = false
enable_redis   = false

extra_tags = {
  Stack = "full"
}
