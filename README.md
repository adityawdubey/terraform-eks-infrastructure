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

- **Terraform:** v1.3.0+
- **AWS ~> 5.0:** EKS, VPC, IAM
- **Kubernetes:** v2.0+

## Features

- Automated provisioning of an EKS cluster with VPC, subnets, and managed node groups
- Integration of AWS Load Balancer Controller and Amazon EBS CSI Driver using IRSA
- Kubernetes RBAC best practices for secure access control
- Automated deployment of add-ons with proper IAM permissions
- High availability configuration across multiple availability zones


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


### Deployment

1. Initialize Terraform:

```bash
terraform init
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
