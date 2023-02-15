data "aws_vpc" "vpc" {
  tags = var.vpc_tags
}

resource "aws_security_group" "aurora" {
  vpc_id = data.aws_vpc.vpc.id
  name   = "${var.project}-${var.environment}-aurora-cluster"

  tags = merge(
    { "Name" = "${var.project}-${var.environment}-aurora-cluster" },
    local.tags
  )
}

data "aws_subnet" "database" {
  for_each = toset(data.aws_subnets.database.ids)

  id = each.key
}

resource "aws_security_group_rule" "ingress" {
  type        = "ingress"
  description = "Only allows connections to database port"

  from_port = aws_rds_cluster.aurora.port
  to_port   = aws_rds_cluster.aurora.port
  protocol  = "tcp"

  cidr_blocks       = var.public_access ? ["0.0.0.0/0"] : values(data.aws_subnet.database)[*].cidr_block
  security_group_id = aws_security_group.aurora.id
}
