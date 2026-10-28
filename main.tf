# VPC
module "vpc" {
  source   = "./vpc"
  vpc_name = var.vpc_name
  azs      = var.azs
}

# EKS
module "eks" {
  source                       = "./eks"
  cluster_name                 = var.cluster_name
  kubernetes_version           = var.kubernetes_version
  vpc_id                       = module.vpc.vpc_id
  subnet_ids                   = module.vpc.private_subnets_ids
  ebs_csi_irsa_role_arn        = module.iam.ebs_csi_irsa_role_arn
  node_instance_types          = var.node_instance_types
  node_desired_size            = var.node_desired_size
  node_min_size                = var.node_min_size
  node_max_size                = var.node_max_size
  cluster_admin_principal_arns = var.cluster_admin_principal_arns
}

# IAM
module "iam" {
  source            = "./iam"
  cluster_name      = var.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
}

# Load Balancer Controller
module "load_balancer_controller" {
  source                                 = "./load_balancer_controller"
  cluster_name                           = module.eks.cluster_name
  load_balancer_controller_irsa_role_arn = module.iam.load_balancer_controller_irsa_role_arn
  vpc_id                                 = module.vpc.vpc_id
  aws_region                             = var.aws_region
  eks_depends_on                         = module.eks
}

# Cluster Autoscaler
module "cluster_autoscaler" {
  source         = "./cluster_autoscaler"
  cluster_name   = module.eks.cluster_name
  aws_region     = var.aws_region
  eks_depends_on = module.eks
}