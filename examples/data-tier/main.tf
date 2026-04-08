module "network" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = var.extra_tags
}

module "aurora" {
  count  = var.enable_aurora ? 1 : 0
  source = "../../modules/aurora_rds"

  project_name               = var.project_name
  environment                = var.environment
  vpc_id                     = module.network.vpc_id
  private_subnet_ids         = module.network.private_subnet_ids
  allowed_security_group_ids = []
  allowed_cidr_blocks        = [var.vpc_cidr]
  tags                       = var.extra_tags
}

module "redis" {
  count  = var.enable_redis ? 1 : 0
  source = "../../modules/elasticache_redis"

  project_name               = var.project_name
  environment                = var.environment
  vpc_id                     = module.network.vpc_id
  private_subnet_ids         = module.network.private_subnet_ids
  allowed_security_group_ids = []
  allowed_cidr_blocks        = [var.vpc_cidr]
  tags                       = var.extra_tags
}
