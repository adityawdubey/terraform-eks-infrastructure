# Cluster Autoscaler IAM Role for Pod Identity
resource "aws_iam_role" "cluster_autoscaler" {
  name = "${var.cluster_name}-cluster-autoscaler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowEksAuthToAssumeRoleForPodIdentity"
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    env       = "dev"
    terraform = "true"
  }
}

# Attach Cluster Autoscaler Policy
resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.cluster_autoscaler.name
}

# Pod Identity Association for Cluster Autoscaler
resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "cluster-autoscaler-aws-cluster-autoscaler"  # Helm's default name
  role_arn        = aws_iam_role.cluster_autoscaler.arn
}

# Helm Release for Cluster Autoscaler
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.37.0"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  # Let Helm create the service account with default name

  # Enable scale down
  set {
    name  = "extraArgs.scale-down-enabled"
    value = "true"
  }

  set {
    name  = "extraArgs.scale-down-delay-after-add"
    value = "10m"
  }

  set {
    name  = "extraArgs.scale-down-unneeded-time"
    value = "10m"
  }

  # Skip nodes with system pods
  set {
    name  = "extraArgs.skip-nodes-with-system-pods"
    value = "false"
  }

  depends_on = [var.eks_depends_on]
}