provider "postgresql" {
  host      = aws_rds_cluster.aurora.endpoint
  port      = aws_rds_cluster.aurora.port
  database  = aws_rds_cluster.aurora.database_name
  username  = var.master_username
  password  = data.aws_secretsmanager_secret_version.superuser_password.secret_string
  superuser = false
}

locals {
  # TODO: Create logic to also create databases when using MySQL
  create_databases = toset(var.engine == "aurora-postgresql" ? var.create_databases : [])
}

# ATTENTION: The auto generation of password is disabled here to make results reproducible,
# but they should be enabled in real life.

# data "aws_secretsmanager_secret_version" "user_password" {
#   for_each = local.create_databases
#
#   secret_id  = aws_secretsmanager_secret.user_password[each.key].id
#   version_id = aws_secretsmanager_secret_version.user_password[each.key].version_id
# }

resource "postgresql_role" "user" {
  for_each   = local.create_databases
  depends_on = [aws_rds_cluster_instance.aurora, aws_security_group_rule.ingress]

  name     = each.key
  login    = true
  # password = data.aws_secretsmanager_secret_version.user_password[each.key].secret_string
  password = each.key
}

resource "postgresql_database" "db" {
  for_each   = local.create_databases
  depends_on = [postgresql_role.user]

  name  = each.key
  owner = each.key
}
