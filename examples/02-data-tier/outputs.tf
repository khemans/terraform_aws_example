output "vpc_id" {
  value = module.network.vpc_id
}

output "aurora_endpoint" {
  value = module.aurora.cluster_endpoint
}

output "redis_primary_endpoint" {
  value = module.redis.primary_endpoint_address
}
