locals {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    project     = var.project,
    environment = var.environment
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr

  enable_dns_support   = true
  enable_dns_hostnames = var.expose_database

  tags = merge(
    { "Name" = "${var.project}-${var.environment}" },
    local.tags
  )
}
