module "network" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  tags               = var.extra_tags
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
