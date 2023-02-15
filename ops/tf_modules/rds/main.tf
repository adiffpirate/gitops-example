locals {
  tags = {
    project     = var.project,
    environment = var.environment
  }
}

data "aws_secretsmanager_secret_version" "superuser_password" {
  secret_id  = aws_secretsmanager_secret.superuser_password.id
  version_id = aws_secretsmanager_secret_version.superuser_password.version_id
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "${var.project}-${var.environment}-aurora-cluster"
  engine             = var.engine
  engine_version     = var.engine_version
  database_name      = replace(var.project, "/[[:punct:]]/", "")

  availability_zones     = var.azs
  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  master_username = var.master_username
  master_password = data.aws_secretsmanager_secret_version.superuser_password.secret_string

  storage_encrypted = true

  backup_retention_period   = var.backup_retention_period
  preferred_backup_window   = "02:00-04:00"
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${var.project}-${var.environment}-aurora-cluster-final-snapshot"

  enabled_cloudwatch_logs_exports = var.engine == "aurora-postgresql" ? ["postgresql"] : ["audit"]

  tags = merge(
    { "Name" = "${var.project}-${var.environment}-aurora-cluster" },
    local.tags
  )
}

resource "aws_rds_cluster_instance" "aurora" {
  for_each = toset(var.one_instance_per_az ? var.azs : ["single"])

  identifier           = "${var.project}-${var.environment}-instance-${each.key}"
  cluster_identifier   = aws_rds_cluster.aurora.id
  engine               = aws_rds_cluster.aurora.engine
  engine_version       = aws_rds_cluster.aurora.engine_version
  db_subnet_group_name = aws_db_subnet_group.aurora.name
  availability_zone    = contains(var.azs, each.key) ? each.key : ""
  instance_class       = var.instance_type
  publicly_accessible  = var.public_access

  tags = merge(
    { "Name" = "${var.project}-${var.environment}-aurora-instance" },
    local.tags
  )
}

data "aws_subnets" "database" {
  tags = var.subnets_tags
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.project}-${var.environment}-aurora-cluster"
  subnet_ids = data.aws_subnets.database.ids

  tags = merge(
    { "Name" = "${var.project}-${var.environment}-aurora-cluster" },
    local.tags
  )
}
