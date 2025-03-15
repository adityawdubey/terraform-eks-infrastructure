output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "nat_gateway_ids" {
  description = "List of IDs of NAT gateways"
  value = module.vpc.natgw_ids
}

output "azs" {
  description = "A list of availability zones specified as argument."
  value = module.vpc.azs
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value = module.vpc.public_route_table_ids
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value = module.vpc.vpc_cidr_block
}

output "vpc_owner_id" {
  description = "The owner ID of the VPC"
  value = module.vpc.vpc_owner_id
}
