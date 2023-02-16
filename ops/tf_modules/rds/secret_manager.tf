#-----------#
# SuperUser #
#-----------#

resource "aws_secretsmanager_secret" "superuser_password" {
  name = "${var.project}-${var.environment}-aurora-superuser-password"

  tags = merge(
    { "Name" = "${var.project}-${var.environment}-aurora-superuser-password" },
    local.tags
  )
}

resource "random_password" "superuser" {
  length = 40
  override_special = "!#$%&*(){}[]-_=+"
}

resource "aws_secretsmanager_secret_version" "superuser_password" {
  secret_id     = aws_secretsmanager_secret.superuser_password.id
  secret_string = random_password.superuser.result
}

#----------------------#
# Users from bootstrap #
#----------------------#

resource "aws_secretsmanager_secret" "user_password" {
  for_each = local.create_databases

  name = "${var.project}-${var.environment}-aurora-${each.key}-user-password"

  tags = merge(
    { "Name" = "${var.project}-${var.environment}-aurora-${each.key}-user-password" },
    local.tags
  )
}

resource "random_password" "user" {
  for_each = local.create_databases

  length = 40
  override_special = "!#$%&*(){}[]-_=+"
}

resource "aws_secretsmanager_secret_version" "user_password" {
  for_each = local.create_databases

  secret_id     = aws_secretsmanager_secret.user_password[each.key].id
  secret_string = random_password.user[each.key].result
}
