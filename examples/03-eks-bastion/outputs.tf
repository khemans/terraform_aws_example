output "bastion_public_ip" {
  value = var.enable_bastion ? module.bastion[0].public_ip : null
}

output "eks_cluster_name" {
  value = var.enable_eks ? module.eks[0].cluster_name : null
}

output "eks_cluster_endpoint" {
  value = var.enable_eks ? module.eks[0].cluster_endpoint : null
}
