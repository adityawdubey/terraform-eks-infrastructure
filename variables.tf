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


variable "kubernetes_version" {
  description = "Kubernetes version of the EKS control plane"
  type        = string
  default     = "1.35"
}

variable "node_instance_types" {
  description = "Instance types for the managed node group"
  type        = list(string)
  default     = ["m7i-flex.large"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes the Cluster Autoscaler can scale to"
  type        = number
  default     = 4
}
