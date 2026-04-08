aws_region   = "us-east-1"
project_name = "interview-demo"
environment  = "prod"

vpc_cidr = "10.20.0.0/16"

availability_zones = ["us-east-1a", "us-east-1b"]

# All services enabled in prod
enable_aurora = true
enable_redis  = true

extra_tags = {
  CostCenter = "interview"
}
