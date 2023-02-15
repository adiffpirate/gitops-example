variable "project" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability Zones where the VPC will be created"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "The IPv4 CIDR blocks for the Private Subnets"
  type        = list(string)
}

variable "public_subnets_cidr" {
  description = "The IPv4 CIDR blocks for the Public Subnets"
  type        = list(string)
}

variable "database_subnets_cidr" {
  description = "The IPv4 CIDR blocks for the Database Subnets"
  type        = list(string)
}

variable "one_nat_gateway_per_az" {
  description = "Determines whether each AZ should have a NAT Gateway or all AZs should have a single NAT Gateway"
  type        = string
  default     = true
}

variable "expose_database" {
  description = "EXTREMELY DANGEROUS: Determines wheter the database subnets are publicly accesible. Should not be enabled in production"
  type        = string
  default     = false
}
