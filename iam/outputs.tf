output "ebs_csi_irsa_role_arn" {
  description = "ARN of the EBS CSI IRSA role"
  value = module.ebs_csi_irsa_role.iam_role_arn
}

output "load_balancer_controller_irsa_role_arn" {
  description = "ARN of the Load Balancer Controller IRSA role"
  value = module.aws_load_balancer_controller_irsa_role.iam_role_arn
}
