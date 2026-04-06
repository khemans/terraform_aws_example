output "cloudfront_domain" {
  value = module.cdn.distribution_domain_name
}

output "bastion_public_ip" {
  value = var.enable_bastion ? module.bastion[0].public_ip : null
}

output "eks_cluster_endpoint" {
  value = var.enable_eks ? module.eks[0].cluster_endpoint : null
}

output "aurora_endpoint" {
  value = var.enable_aurora ? module.aurora[0].cluster_endpoint : null
}

output "redis_primary_endpoint" {
  value = var.enable_redis ? module.redis[0].primary_endpoint_address : null
}
