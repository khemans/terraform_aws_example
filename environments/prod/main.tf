resource "random_id" "bucket_suffix" {
  byte_length = 4
}

module "network" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = var.extra_tags
}

module "static_bucket" {
  source = "../../modules/s3_bucket"

  project_name      = var.project_name
  environment       = var.environment
  bucket_suffix     = random_id.bucket_suffix.hex
  enable_versioning = true
  tags              = var.extra_tags
}

module "cdn" {
  source = "../../modules/cloudfront_s3"

  project_name                   = var.project_name
  environment                    = var.environment
  s3_bucket_id                   = module.static_bucket.bucket_id
  s3_bucket_arn                  = module.static_bucket.bucket_arn
  s3_bucket_regional_domain_name = module.static_bucket.bucket_domain_name
  default_root_object            = "index.html"
  tags                           = var.extra_tags
}

module "bastion" {
  count  = var.enable_bastion ? 1 : 0
  source = "../../modules/ec2_bastion"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_ids[0]
  ssh_ingress_cidr = var.ssh_ingress_cidr
  tags             = var.extra_tags
}

module "eks" {
  count  = var.enable_eks ? 1 : 0
  source = "../../modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  cluster_version    = var.eks_cluster_version
  tags               = var.extra_tags
}

module "aurora" {
  count  = var.enable_aurora ? 1 : 0
  source = "../../modules/aurora_rds"

  project_name               = var.project_name
  environment                = var.environment
  vpc_id                     = module.network.vpc_id
  private_subnet_ids         = module.network.private_subnet_ids
  allowed_security_group_ids = var.enable_bastion ? [module.bastion[0].security_group_id] : []
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
  allowed_security_group_ids = var.enable_bastion ? [module.bastion[0].security_group_id] : []
  allowed_cidr_blocks        = [var.vpc_cidr]
  tags                       = var.extra_tags
}
