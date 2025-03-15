variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones for VPC subnets"
  type        = list(string)
}