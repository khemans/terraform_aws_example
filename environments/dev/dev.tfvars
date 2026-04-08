aws_region   = "us-east-1"
project_name = "platform-dev-env"
environment  = "dev"

vpc_cidr = "10.100.0.0/16"

public_subnets = {
  "public-1" = {
    cidr_block        = "10.100.0.0/20"
    availability_zone = "us-east-1a"
  }
  "public-2" = {
    cidr_block        = "10.100.16.0/20"
    availability_zone = "us-east-1b"
  }
}

private_subnets = {
  "private-1" = {
    cidr_block        = "10.100.128.0/20"
    availability_zone = "us-east-1a"
  }
  "private-2" = {
    cidr_block        = "10.100.144.0/20"
    availability_zone = "us-east-1b"
  }
}

ssh_ingress_cidr = "0.0.0.0/0"

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

eks_cluster_version = "1.29"

# Disable expensive services in dev to reduce cost
enable_bastion = false
enable_eks     = false
enable_aurora  = false
enable_redis   = false

extra_tags = {
  Stack = "full"
}
