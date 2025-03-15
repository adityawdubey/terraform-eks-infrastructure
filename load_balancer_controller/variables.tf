variable "cluster_id" {
  type = string
  description = "The ID of the EKS cluster"
}

variable "load_balancer_controller_irsa_role_arn" {
  type = string
  description = "The ARN of the IAM role for the Load Balancer Controller"
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "eks_depends_on" {
  description = "Dependencies for the EKS module"
  type        = any
  default     = null
}