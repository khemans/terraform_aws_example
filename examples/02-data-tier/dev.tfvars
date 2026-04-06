aws_region   = "us-east-1"
project_name = "interview-demo"
environment  = "dev"

vpc_cidr = "10.10.0.0/16"

availability_zones = ["us-east-1a", "us-east-1b"]

# Disable expensive services in dev
enable_aurora = false
enable_redis  = false

extra_tags = {
  CostCenter = "interview"
}
