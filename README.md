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

- **Terraform:** v1.11.3+
- **AWS ~> 5.0:** EKS, VPC, IAM
- **Kubernetes:** v2.0+

## Features

- Automated provisioning of an EKS cluster with VPC, subnets, and managed node groups
- A highly available Multi-AZ VPC with public/private subnets and NAT gateways
- Integration of critical EKS add-ons: CoreDNS, kube-proxy, AWS VPC CNI, and EBS CSI Driver
- Kubernetes RBAC best practices for secure access control
- Automated deployment of add-ons with proper IAM permissions
- Deployed the AWS Load Balancer Controller with full Ingress support
- Configured DNS + ALB Ingress to expose workloads securely
- Cluster Autoscaler for automatic scaling of EKS node groups based on pod resource demands


## Setup and Deployment

### Prerequisites

- Terraform CLI
- AWS CLI
- Kubernetes CLI

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/terraform-eks-infrastructure.git
cd terraform-eks-infrastructure
```

2. Configure AWS CLI:

```bash
aws configure
```

3. Create a terraform.tfvars file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

5. Customize the variables in **terraform.tfvars**

    Edit the terraform.tfvars file to tailor the variables to your specific needs.


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

The bucket name is not stored in this repository. Pass it to `terraform init` (locally) or set the `TF_STATE_BUCKET` GitHub Actions variable (CI).

### Deployment

1. Initialize Terraform with your state bucket:

```bash
export TF_STATE_BUCKET=<your-state-bucket-name>
terraform init -backend-config="bucket=$TF_STATE_BUCKET"
```

2. Plan the deployment:

```bash
terraform plan
```

3. Apply the configuration:

```bash
terraform apply
```


## Usage

### Accessing the Cluster

1. Set the AWS CLI profile:

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
