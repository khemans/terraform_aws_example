# Data sources for VPC and subnets from remote state
# Note: This assumes you have a VPC remote state configured
# If using remote state, uncomment and configure the data source below:
# data "terraform_remote_state" "vpc" {
#   backend   = "s3"
#   workspace = var.kubernetes_remote_state_workspace
#   config = {
#     bucket = var.kubernetes_remote_state_bucket
#     key    = "vpc/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

# Alternative: Use data sources if VPC is tagged
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "tag:Name"
    values = [for az in var.availability_zones : "${var.vpc_name}-private-${az}"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "tag:Name"
    values = [for az in var.availability_zones : "${var.vpc_name}-public-${az}"]
  }
}

# ECS Cluster
module "cluster" {
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//cluster?ref=main"

  cluster_name = "${var.project_name}-${var.environment}"
  tags         = var.tags
}

# IAM Roles
module "iam" {
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//iam?ref=main"

  execution_role_name = "${var.project_name}-execution-${var.environment}"
  task_role_name      = "${var.project_name}-task-${var.environment}"
  tags                = var.tags
}

# CloudWatch Logs
module "logs" {
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//logs?ref=main"

  log_group_name    = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

# ECR Repository
module "ecr" {
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//ecr?ref=main"

  repository_name = "${var.project_name}-${var.environment}"
  tags            = var.tags
}

# Security Groups
module "security_groups" {
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//security-groups?ref=main"

  vpc_id                  = data.aws_vpc.main.id
  lb_security_group_name  = "${var.project_name}-alb-${var.environment}"
  ecs_security_group_name = "${var.project_name}-tasks-${var.environment}"
  app_port                = var.container_port
  ingress_ports           = [80, 443]
  tags                    = var.tags
}

# Application Load Balancer
module "alb" {
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//alb?ref=main"

  alb_name          = "${var.project_name}-alb-${var.environment}"
  subnet_ids        = data.aws_subnets.public.ids
  security_group_ids = [module.security_groups.lb_security_group_id]
  internal          = false
  tags              = var.tags
}

# Target Group
module "target_group" {
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//target-group?ref=main"

  target_group_name = "${var.project_name}-tg-${var.environment}"
  vpc_id            = data.aws_vpc.main.id
  port              = var.container_port
  health_check_path = var.health_check_path
  tags              = var.tags
}

# Task Definition
locals {
  # Use image.repository if provided, otherwise use ECR repository URL
  image_url = var.image.repository != "" ? "${var.image.repository}:${var.image.tag}" : "${module.ecr.repository_url}:${var.container_tag}"
  
  container_definitions = jsonencode([{
    name      = "${var.project_name}-app"
    image     = local.image_url
    essential = true
    portMappings = [{
      containerPort = var.container_port
      protocol      = "tcp"
    }]
    environment = var.container_environment
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = module.logs.log_group_name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

module "task_definition" {
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//task-definition?ref=main"

  family             = "${var.project_name}-${var.environment}"
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  cpu                = var.fargate_cpu
  memory             = var.fargate_memory
  container_definitions = local.container_definitions
  tags               = var.tags
}

# ECS Service
module "service" {
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//service?ref=main"

  service_name           = "${var.project_name}-service-${var.environment}"
  cluster_name           = module.cluster.cluster_name
  task_definition_arn    = module.task_definition.task_definition_arn
  desired_count         = var.desired_count
  security_group_ids     = [module.security_groups.ecs_security_group_id]
  subnet_ids             = data.aws_subnets.private.ids
  assign_public_ip       = false
  target_group_arn       = module.target_group.target_group_arn
  container_name         = "${var.project_name}-app"
  container_port         = var.container_port
  tags                   = var.tags
}

# Auto Scaling (optional)
module "autoscaling" {
  count  = var.enable_autoscaling ? 1 : 0
  source = "git::ssh://git@gitlab.com/company/cloud-infrastructure/global-modules/fargate.git//autoscaling?ref=main"

  service_name  = module.service.service_name
  cluster_name  = module.cluster.cluster_name
  min_capacity  = var.min_capacity
  max_capacity  = var.max_capacity
  tags          = var.tags
}

