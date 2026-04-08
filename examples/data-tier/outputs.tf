output "vpc_id" {
  value = module.network.vpc_id
}

output "aurora_endpoint" {
  value = var.enable_aurora ? module.aurora[0].cluster_endpoint : null
}

output "redis_primary_endpoint" {
  value = var.enable_redis ? module.redis[0].primary_endpoint_address : null
}
