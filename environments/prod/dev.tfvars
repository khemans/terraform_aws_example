# Dev-shaped values for dry-runs or comparisons — primary prod apply uses prod.tfvars.
aws_region   = "us-east-1"
project_name = "interview-platform"
environment  = "dev"

vpc_cidr = "10.110.0.0/16"

availability_zones = ["us-east-1a", "us-east-1b"]

ssh_ingress_cidr = "0.0.0.0/0"

eks_cluster_version = "1.29"

extra_tags = {
  Stack = "full"
}
