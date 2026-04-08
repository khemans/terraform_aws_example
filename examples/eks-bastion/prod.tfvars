aws_region   = "us-east-1"
project_name = "interview-demo"
environment  = "prod"

vpc_cidr = "10.40.0.0/16"

public_subnets = {
  "public-1" = {
    cidr_block        = "10.40.0.0/20"
    availability_zone = "us-east-1a"
  }
  "public-2" = {
    cidr_block        = "10.40.16.0/20"
    availability_zone = "us-east-1b"
  }
}

private_subnets = {
  "private-1" = {
    cidr_block        = "10.40.128.0/20"
    availability_zone = "us-east-1a"
  }
  "private-2" = {
    cidr_block        = "10.40.144.0/20"
    availability_zone = "us-east-1b"
  }
}

ssh_ingress_cidr = "203.0.113.10/32"

eks_cluster_version = "1.29"

# All services enabled in prod
enable_bastion = true
enable_eks     = true
