variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs for the EKS nodes."
}

variable "ebs_csi_irsa_role_arn" {
  type        = string
  description = "The ARN of the EBS CSI IRSA role."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version of the EKS control plane."
}

variable "node_instance_types" {
  type        = list(string)
  description = "Instance types for the managed node group."
}

variable "node_desired_size" {
  type        = number
  description = "Desired number of worker nodes."
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of worker nodes."
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of worker nodes."
}
