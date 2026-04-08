aws_region   = "us-east-1"
project_name = "interview-demo"
environment  = "prod"

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

extra_tags = {
  CostCenter = "interview"
  Owner      = "candidate"
}
