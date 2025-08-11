variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "eks_depends_on" {
  description = "Dependency on EKS cluster creation"
  type        = any
  default     = null
}