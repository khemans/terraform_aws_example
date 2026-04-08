aws_region   = "us-east-1"
project_name = "platform-prod-env"
environment  = "prod"

vpc_cidr = "10.200.0.0/16"

public_subnets = {
  "public-1" = {
    cidr_block        = "10.200.0.0/20"
    availability_zone = "us-east-1a"
  }
  "public-2" = {
    cidr_block        = "10.200.16.0/20"
    availability_zone = "us-east-1b"
  }
}

private_subnets = {
  "private-1" = {
    cidr_block        = "10.200.128.0/20"
    availability_zone = "us-east-1a"
  }
  "private-2" = {
    cidr_block        = "10.200.144.0/20"
    availability_zone = "us-east-1b"
  }
}

ssh_ingress_cidr = "203.0.113.10/32"

# CloudFront settings
min_ttl     = 0
default_ttl = 3600
max_ttl     = 86400
compress    = true

# S3 bucket public access block settings
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true

# Database and Redis ports
database_port = 5432
redis_port    = 6379

eks_cluster_version = "1.29"

# All services enabled in prod
enable_bastion = true
enable_eks     = true
enable_aurora  = true
enable_redis   = true

extra_tags = {
  Stack = "full"
}
