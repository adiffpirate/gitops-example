output "endpoint" {
  description = "The DNS address of the Aurora Master Instance"
  value       = module.rds.endpoint
}

output "reader_endpoint" {
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
  value       = module.rds.reader_endpoint
}

output "port" {
  description = "The port on which the DB accepts connections"
  value       = module.rds.port
}

output "master_username" {
  description = "Name of the Master User"
  value       = module.rds.master_username
}

output "master_password" {
  description = "Name of the Master User"
  value       = module.rds.master_password
  sensitive   = true
}

output "default_database" {
  description = "Name of the default database created by Aurora"
  value       = module.rds.default_database
  sensitive   = true
}

output "cluster_name" {
  description = "Aurora Cluster Name"
  value       = module.rds.cluster_name
}

output "cluster_id" {
  description = "Aurora Cluster ID"
  value       = module.rds.cluster_id
}

output "cluster_arn" {
  description = "Aurora Cluster Name"
  value       = module.rds.cluster_arn
}

output "instances_name" {
  description = "List containing each Instance Name"
  value       = module.rds.instances_name
}

output "instances_id" {
  description = "List containing each Instance ID"
  value       = module.rds.instances_id
}

output "instances_arn" {
  description = "List containing each Instance ARN"
  value       = module.rds.instances_arn
}

output "engine" {
  description = "Database engine used for this Aurora Cluster"
  value       = module.rds.engine
}

output "engine_version" {
  description = "Database engine version"
  value       = module.rds.engine_version
}

output "created_databases" {
  description = "Databases, users and password created by the `create_databases` variable"
  value       = module.rds.created_databases
  sensitive   = true
}
