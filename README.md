# Terraform-EKS-Infrastructure

A Terraform-based IaC that provisions an Amazon EKS cluster on AWS with VPC, subnets, managed node groups, and add-ons (AWS Load Balancer Controller &amp; Amazon EBS CSI Driver) using IRSA and Kubernetes RBAC best practices.

blog: https://adityadubey.tech/deploying-an-amazon-eks-cluster-with-terraform

## Table of Contents

- [Architecture](#architecture)
- [Technologies Used](#technologies-used)
- [Features](#features)
- [Setup and Deployment](#setup-and-deployment)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Create the Terraform state bucket (one-time)](#create-the-terraform-state-bucket-one-time)
  - [Deployment](#deployment)
  - [Destroy](#destroy)
- [Usage](#usage)
  - [Accessing the Cluster](#accessing-the-cluster)
- [References](#references)
- [Contributing](#contributing)

## Architecture

The infrastructure follows a resilient, secure, and highly available design spanning multiple AWS Availability Zones.

![EKS Arch-Redacto Architecture](https://github.com/user-attachments/assets/eeae34e1-735e-44d4-8266-836e6e989b40)


- **Public Subnets:** These subnets house NAT Gateways that allow outbound internet access for resources in private subnets.
- **Private Subnets:** These subnets contain the EKS worker nodes, providing an additional layer of security by isolating them from direct internet access.
- **Ingress Controller:** Deployed as part of the EKS cluster to manage external access to services running within the cluster.

## Technologies Used

- **Terraform:** 1.17 (CI uses 1.17.1)
- **AWS ~> 5.0:** EKS, VPC, IAM
- **Amazon EKS:** 1.35

## Features

- Automated provisioning of an EKS cluster with VPC, subnets, and managed node groups
- A highly available Multi-AZ VPC with public/private subnets and NAT gateways
- Integration of critical EKS add-ons: CoreDNS, kube-proxy, AWS VPC CNI, and EBS CSI Driver
- Kubernetes RBAC best practices for secure access control
- Automated deployment of add-ons with proper IAM permissions
- Deployed the AWS Load Balancer Controller with full Ingress support
- Cluster Autoscaler for automatic scaling of EKS node groups based on pod resource demands


## Setup and Deployment

### Prerequisites

- Terraform CLI
- AWS CLI
- Kubernetes CLI

### Installation

1. Clone the repository and configure the AWS CLI:

```bash
git clone https://github.com/adityawdubey/terraform-eks-infrastructure.git
cd terraform-eks-infrastructure
aws configure
```

2. Set your values in `environments/main/terraform.tfvars` (region, VPC and cluster names, availability zones, cluster admins) and your state bucket in `environments/main/backend.s3.tfbackend`.


### Create the Terraform state bucket (one-time)

Terraform state is stored remotely in S3 with native S3 state locking (`use_lockfile = true` in `backend.tf`). Terraform does not create this bucket, and this repository intentionally does not create it either. Create it **once per AWS account**, before the first `terraform init`.

Use a predictable, globally unique name, for example `<project>-tfstate-<account-id>-<region>`. Create the bucket in the same region as the backend in `backend.tf` (`ap-south-1`):

```bash
export AWS_REGION=ap-south-1
export TF_STATE_BUCKET="eks-infra-tfstate-$(aws sts get-caller-identity --query Account --output text)-${AWS_REGION}"

aws s3api create-bucket --bucket "$TF_STATE_BUCKET" --region "$AWS_REGION" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION"
aws s3api put-bucket-versioning --bucket "$TF_STATE_BUCKET" \
  --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket "$TF_STATE_BUCKET" \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
aws s3api put-public-access-block --bucket "$TF_STATE_BUCKET" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

> [!IMPORTANT]
> - **Do not let this Terraform stack create its own state bucket.** The bucket must exist before `terraform init`, and `terraform destroy` would try to delete the bucket that holds the state it is using.
> - **Do not let CI create a missing bucket.** A new bucket means an empty state, and Terraform would try to recreate infrastructure that already exists. If the bucket is missing, CI should fail.
> - **Do not delete the bucket or its versions** while any infrastructure managed by this state still exists.

Put the bucket name in `environments/main/backend.s3.tfbackend`. Local runs and CI both read it from there.

### Deployment

Pushes to `main` deploy automatically through GitHub Actions (setup: [.github/workflows/README.md](.github/workflows/README.md)). To preview or deploy locally with the same settings:

```bash
terraform init -backend-config=environments/main/backend.s3.tfbackend
terraform plan -var-file=environments/main/terraform.tfvars -out=tfplan
terraform apply tfplan
```

> [!NOTE]
> Apply from either CI or your machine, not both. Terraform gives cluster admin to whoever runs `apply`, so switching between them changes that access each time.

### Destroy

```bash
terraform plan -destroy -var-file=environments/main/terraform.tfvars -out=destroy.tfplan
terraform apply destroy.tfplan
```

The state bucket isn't part of the stack and isn't deleted. Disable the workflow first, otherwise the next push to `main` recreates everything.


## Usage

### Accessing the Cluster

1. Set the AWS CLI profile:

Your IAM identity must be listed in `cluster_admin_principal_arns`; otherwise `kubectl` returns `Unauthorized`.

Run the following command to update your **kubeconfig** file, allowing `kubectl` to communicate with the EKS cluster:

```bash
aws eks update-kubeconfig --name <eks_cluster_name> --region <aws_region>
```

2. Verify the connection:

```bash
kubectl get nodes
```


## References

- [Amazon EKS Documentation](https://docs.aws.amazon.com/eks/)
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
