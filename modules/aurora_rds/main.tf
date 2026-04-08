locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_security_group" "aurora" {
  name        = "${var.project_name}-${var.environment}-aurora-sg"
  description = "Aurora access"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_security_group_ids
    content {
      description     = "From ${ingress.value}"
      from_port       = var.database_port
      to_port         = var.database_port
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      description = "From CIDR ${ingress.value}"
      from_port   = var.database_port
      to_port     = var.database_port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-aurora-sg" })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-aurora"
  subnet_ids = var.private_subnet_ids

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-aurora-subnets" })
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = "${var.project_name}-${var.environment}-aurora"
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  engine_version     = var.engine_version
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = random_password.master.result

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  storage_encrypted = true

  serverlessv2_scaling_configuration {
    min_capacity = var.serverlessv2_min_capacity
    max_capacity = var.serverlessv2_max_capacity
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-aurora" })
}

resource "random_password" "master" {
  length  = 16
  special = false
}

resource "aws_rds_cluster_instance" "this" {
  identifier         = "${var.project_name}-${var.environment}-aurora-1"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-aurora-instance" })
}
