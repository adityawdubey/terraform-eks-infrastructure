# allows you to expose the necessary information for other modules to use.

output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data for the EKS cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_managed_node_groups" {
  description = "Map of EKS managed node groups."
  value       = module.eks.eks_managed_node_groups
}

output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster role"
  value = module.eks.cluster_iam_role_arn
}

# output "eks_node_group_role_arn" {
#   description = "ARN of the EKS node group role"
#   value = module.eks.no
# }

output "oidc_provider" {
  description = "OIDC provider"
  value = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value = module.eks.oidc_provider_arn
}

