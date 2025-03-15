provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

/*

when i use cluster_id instead of cluster_name, i get the following error:
│ Error: Null value found in list
│ 
│   with provider["registry.terraform.io/hashicorp/helm"],
│   on providers.tf line 49, in provider "helm":
│   49:       args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
│ 
│ Null values are not allowed for this attribute value.

*/


# Below are the commented out code that works as well:

# # Data source to fetch EKS cluster auth details
# data "aws_eks_cluster_auth" "this" {
#   name = module.eks.cluster_name
# }

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#     token                  = module.eks.cluster_auth_token
#   }
# }