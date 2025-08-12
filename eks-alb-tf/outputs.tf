output "cluster_name" {
  value       = module.eks.cluster_name
  description = "Nombre del cluster EKS"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "Endpoint del API server"
}

output "cluster_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "ARN del OIDC provider"
}

output "update_kubeconfig_command" {
  description = "Comando sugerido para configurar kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}
