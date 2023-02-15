output "name" {
  description = "VPC Name"
  value       = "${var.project}-${var.environment}"
}

output "id" {
  description = "VPC ID"
  value       = local.vpc_id
}

output "cidr" {
  description = "VPC CIDR block"
  value       = var.cidr
}

output "arn" {
  description = "VPC ARN"
  value       = aws_vpc.vpc.arn
}

output "private_subnets_cidr" {
  description = "CIDR block for the private subnets"
  value       = var.private_subnets_cidr
}

output "private_subnets_ids" {
  description = "IDs for the private subnets on the VPC"
  value       = values(aws_subnet.private)[*].id
}

output "private_subnets_arns" {
  description = "ARNs for the private subnets on the VPC"
  value       = values(aws_subnet.private)[*].arn
}

output "public_subnets_cidr" {
  description = "CIDR block for the public subnets"
  value       = var.public_subnets_cidr
}

output "public_subnets_ids" {
  description = "IDs for the public subnets on the VPC"
  value       = values(aws_subnet.public)[*].id
}

output "public_subnets_arns" {
  description = "ARNs for the public subnets on the VPC"
  value       = values(aws_subnet.public)[*].arn
}

output "database_subnets_cidr" {
  description = "CIDR block for the database subnets"
  value       = var.database_subnets_cidr
}

output "database_subnets_ids" {
  description = "IDs for the database subnets on the VPC"
  value       = values(aws_subnet.database)[*].id
}

output "database_subnets_arns" {
  description = "ARNs for the database subnets on the VPC"
  value       = values(aws_subnet.database)[*].arn
}
