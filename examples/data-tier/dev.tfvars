aws_region   = "us-east-1"
project_name = "interview-demo"
environment  = "dev"

vpc_cidr = "10.10.0.0/16"

public_subnets = {
  "public-1" = {
    cidr_block        = "10.10.0.0/20"
    availability_zone = "us-east-1a"
  }
  "public-2" = {
    cidr_block        = "10.10.16.0/20"
    availability_zone = "us-east-1b"
  }
}

private_subnets = {
  "private-1" = {
    cidr_block        = "10.10.128.0/20"
    availability_zone = "us-east-1a"
  }
  "private-2" = {
    cidr_block        = "10.10.144.0/20"
    availability_zone = "us-east-1b"
  }
}

# Database and Redis ports
database_port = 5432
redis_port    = 6379

# Disable expensive services in dev
enable_aurora = false
enable_redis  = false

extra_tags = {
  CostCenter = "interview"
}
