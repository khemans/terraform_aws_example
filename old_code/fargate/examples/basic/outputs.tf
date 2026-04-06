output "cluster_name" {
  value       = module.cluster.cluster_name
  description = "Name of the ECS cluster"
}

output "service_name" {
  value       = module.service.service_name
  description = "Name of the ECS service"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the load balancer"
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "URL of the ECR repository"
}

output "log_group_name" {
  value       = module.logs.log_group_name
  description = "Name of the CloudWatch log group"
}

