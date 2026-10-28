aws_region   = "ap-south-1"
vpc_name     = "eks-vpc"
cluster_name = "eks-cluster"
azs          = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

# Cluster admins besides the CI role, which is the cluster creator
cluster_admin_principal_arns = ["arn:aws:iam::712242347460:user/aditya_tech"]
