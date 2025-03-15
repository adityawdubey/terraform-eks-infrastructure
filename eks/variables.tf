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

