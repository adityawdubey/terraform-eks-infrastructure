variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

# VPC

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones for VPC subnets"
  type        = list(string)
}

# EKS

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# IAM

variable "eks_cluster_role" {
  description = "EKS cluster role"
  type        = string
}

variable "eks_node_group_role" {
  description = "EKS node group role"
  type        = string
}

