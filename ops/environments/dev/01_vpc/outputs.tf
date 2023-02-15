output "name" {
  description = "VPC Name"
  value       = module.vpc.name
}

output "id" {
  description = "VPC ID"
  value       = module.vpc.id
}

output "cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.cidr
}

output "private_subnets_cidr" {
  description = "CIDR block for the private subnets"
  value       = module.vpc.private_subnets_cidr
}

output "private_subnets_ids" {
  description = "IDs for the private subnets on the VPC"
  value       = module.vpc.private_subnets_ids
}

output "private_subnets_arns" {
  description = "ARNs for the private subnets on the VPC"
  value       = module.vpc.private_subnets_arns
}

output "public_subnets_cidr" {
  description = "CIDR block for the public subnets"
  value       = module.vpc.public_subnets_cidr
}
output "public_subnets_ids" {
  description = "IDs for the public subnets on the VPC"
  value       = module.vpc.public_subnets_ids
}

output "public_subnets_arns" {
  description = "ARNs for the public subnets on the VPC"
  value       = module.vpc.public_subnets_arns
}

output "database_subnets_cidr" {
  description = "CIDR block for the database subnets"
  value       = module.vpc.database_subnets_cidr
}
output "database_subnets_ids" {
  description = "IDs for the database subnets on the VPC"
  value       = module.vpc.database_subnets_ids
}

output "database_subnets_arns" {
  description = "ARNs for the database subnets on the VPC"
  value       = module.vpc.database_subnets_arns
}
