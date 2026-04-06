output "cloudfront_domain" {
  value = module.cdn.distribution_domain_name
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "aurora_endpoint" {
  value = module.aurora.cluster_endpoint
}

output "redis_primary_endpoint" {
  value = module.redis.primary_endpoint_address
}
