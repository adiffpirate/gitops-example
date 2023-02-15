output "endpoint" {
  description = "The DNS address of the Aurora Master Instance"
  value       = aws_rds_cluster.aurora.endpoint
}

output "reader_endpoint" {
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "port" {
  description = "The port on which the DB accepts connections"
  value       = aws_rds_cluster.aurora.port
}

output "master_username" {
  description = "Name of the Master User"
  value       = var.master_username
}

output "master_password" {
  description = "Name of the Master User"
  value       = data.aws_secretsmanager_secret_version.superuser_password.secret_string
  sensitive   = true
}

output "default_database" {
  description = "Name of the default database created by Aurora"
  value       = aws_rds_cluster.aurora.database_name
  sensitive   = true
}

output "cluster_name" {
  description = "Aurora Cluster Name"
  value       = aws_rds_cluster.aurora.cluster_identifier
}

output "cluster_id" {
  description = "Aurora Cluster ID"
  value       = aws_rds_cluster.aurora.id
}

output "cluster_arn" {
  description = "Aurora Cluster Name"
  value       = aws_rds_cluster.aurora.arn
}

output "instances_name" {
  description = "List containing each Instance Name"
  value       = values(aws_rds_cluster_instance.aurora)[*].identifier
}

output "instances_id" {
  description = "List containing each Instance ID"
  value       = values(aws_rds_cluster_instance.aurora)[*].id
}

output "instances_arn" {
  description = "List containing each Instance ARN"
  value       = values(aws_rds_cluster_instance.aurora)[*].arn
}

output "engine" {
  description = "Database engine used for this Aurora Cluster"
  value       = aws_rds_cluster.aurora.engine
}

output "engine_version" {
  description = "Database engine version"
  value       = aws_rds_cluster.aurora.engine_version
}

output "created_databases" {
  description = "Databases, users and password created by the `create_databases` variable"
  sensitive   = true
  
  value = {
    for db in var.create_databases : db => {
      "user" = db,
      "password" = data.aws_secretsmanager_secret_version.user_password[db].secret_string
    }
  }
}
