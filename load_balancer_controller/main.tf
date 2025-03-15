/*
This configuration deploys the AWS Load Balancer Controller to the EKS cluster
The controller manages AWS Application Load Balancers (ALB) and Network Load Balancers (NLB)
for Kubernetes services and ingresses
*/


# Deploy AWS Load Balancer Controller using Helm
resource "helm_release" "aws_load_balancer_controller" {
  name = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.4.3"


  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "clusterName"
    value = "eks-cluster"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.load_balancer_controller_irsa_role_arn
  }

  set {
    name  = "region"
    value = var.aws_region
  }

}
