module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = true
  one_nat_gateway_per_az = true

  # DNS Parameters in VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Name = "Public Subnet"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    Name = "Private Subnet"
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    terraform   = "true"
    env = "dev"
  }
}
