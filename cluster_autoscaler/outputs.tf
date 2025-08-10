output "cluster_autoscaler_role_arn" {
  description = "ARN of the Cluster Autoscaler IAM role"
  value       = aws_iam_role.cluster_autoscaler.arn
}

output "cluster_autoscaler_pod_identity_association_id" {
  description = "ID of the EKS Pod Identity Association"
  value       = aws_eks_pod_identity_association.cluster_autoscaler.association_id
}

output "cluster_autoscaler_release_name" {
  description = "Name of the Cluster Autoscaler Helm release"
  value       = helm_release.cluster_autoscaler.name
}

output "cluster_autoscaler_namespace" {
  description = "Namespace where Cluster Autoscaler is deployed"
  value       = helm_release.cluster_autoscaler.namespace
}
