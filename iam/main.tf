# IAM Role for EBS CSI
module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${var.cluster_name}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
  

}

# IAM Role for Load Balancer Controller
module "aws_load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.3.1"

  role_name = "${var.cluster_name}-aws-load-balancer-controller"

  attach_load_balancer_controller_policy = false # Disable default policy attachment

  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# Create the policy using the HTTP data source to fetch the policy JSON
data "http" "load_balancer_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"

  # Optional: Add request headers
  request_headers = {
    Accept = "application/json"
  }
}

# Create the AWS Load Balancer Controller IAM Policy from the fetched document
resource "aws_iam_policy" "load_balancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = data.http.load_balancer_controller_policy.response_body
}

# Attach the created policy to the role
resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role       = module.aws_load_balancer_controller_irsa_role.iam_role_name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}