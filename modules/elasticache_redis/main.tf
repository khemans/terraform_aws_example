locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_security_group" "redis" {
  name        = "${var.project_name}-${var.environment}-redis-sg"
  description = "ElastiCache Redis"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_security_group_ids
    content {
      description     = "From ${ingress.value}"
      from_port       = var.redis_port
      to_port         = var.redis_port
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      description = "From CIDR ${ingress.value}"
      from_port   = var.redis_port
      to_port     = var.redis_port
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

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-redis-sg" })
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-redis"
  subnet_ids = var.private_subnet_ids

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-redis-subnets" })
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = "${var.project_name}-${var.environment}-redis"
  description                = "Redis for ${var.project_name} ${var.environment}"

  engine             = "redis"
  engine_version     = var.engine_version
  node_type          = var.node_type
  num_cache_clusters = var.num_cache_nodes
  port               = var.redis_port

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.redis.id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-redis" })
}
