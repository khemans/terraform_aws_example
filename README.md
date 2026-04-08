# Terraform AWS Example

## Introduction

This repository was created for demo purposes for my interview with Charter Communications. It showcases Terraform infrastructure code, based on my previous experiences and deployment methods I've used in the past. The `old_code` directory contains code from my previous employment that I have available.

This is a Terraform project for deploying a modular, multi-environment cloud platform on AWS. It provides reusable modules and environment-specific configurations for building scalable applications with networking, compute, storage, database, and caching infrastructure.

## Project Structure

### Modules (`modules/`)
Self-contained Terraform components for specific AWS services:
- **vpc**: VPC setup with configurable public/private subnets across multiple availability zones
- **s3_bucket**: S3 bucket with versioning, encryption, and security controls
- **cloudfront_s3**: CloudFront CDN distribution for S3 static content with Origin Access Control
- **ec2_bastion**: EC2 bastion host for SSH access to private resources
- **eks**: EKS Kubernetes cluster with IAM roles and policies
- **aurora_rds**: Aurora MySQL/PostgreSQL database with security groups
- **elasticache_redis**: Redis cluster for caching/session management

### Environments (`environments/`)
Two fully configured deployments that compose modules:

#### Development (`environments/dev/`)
- Cost-optimized testing and development environment
- VPC CIDR: `10.100.0.0/16` (us-east-1)
- Services: Network, S3 bucket, CloudFront CDN
- SSH Access: Open for development

#### Production (`environments/prod/`)
- Full-featured production deployment
- VPC CIDR: `10.200.0.0/16` (us-east-1)
- Services: All (Bastion, EKS, Aurora, Redis)
- SSH Access: Restricted to specific IP
- Database: PostgreSQL on Aurora
- Cache: Redis

### Examples (`examples/`)
Specialized reference implementations:
- **data-tier**: VPC + Aurora RDS + ElastiCache Redis for backend services
- **eks-bastion**: VPC + EKS Cluster + EC2 Bastion for Kubernetes applications
- **static-site**: S3 Bucket + CloudFront CDN for static websites

## Key Features
- **Modularity**: Decoupled AWS services for flexible composition
- **Environment Flexibility**: Same modules deployed differently with tfvars overrides
- **Security**: S3 public access blocked, restricted security groups, least-privilege IAM
- **Tagging**: Consistent naming and tagging across resources
- **Conditional Deployment**: Optional resources via feature flags
- **Multi-AZ**: High availability across availability zones

## Deployment Patterns
1. **Static Web App**: Use `static-site` example
2. **Microservices on Kubernetes**: Use `eks-bastion` + data-tier modules
3. **Backend API with Database**: Use `data-tier` example
4. **Full Platform**: Combine all modules via `environments/prod`

All outputs (CloudFront domain, bastion IP, cluster endpoint, database endpoint, Redis endpoint) are exported for application connectivity.