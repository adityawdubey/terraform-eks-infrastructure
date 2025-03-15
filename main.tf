# VPC
module "vpc" {
  source   = "./vpc"
  vpc_name = var.vpc_name
  azs      = var.azs
}

# EKS
module "eks" {
  source                = "./eks"
  cluster_name          = var.cluster_name
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnets_ids
  ebs_csi_irsa_role_arn = module.iam.ebs_csi_irsa_role_arn
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
  cluster_id                             = module.eks.cluster_id
  load_balancer_controller_irsa_role_arn = module.iam.load_balancer_controller_irsa_role_arn
  vpc_id                                 = module.vpc.vpc_id
  aws_region                             = var.aws_region
  eks_depends_on                         = module.eks
}
