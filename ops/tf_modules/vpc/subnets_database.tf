locals {
  # Map subnets to availability zones
  database_subnets_az_with_cidr = { for az in var.azs : az => element(var.database_subnets_cidr, index(var.azs, az)) }
}

resource "aws_subnet" "database" {
  for_each = local.database_subnets_az_with_cidr

  vpc_id            = local.vpc_id
  availability_zone = each.key
  cidr_block        = each.value

  tags = merge(
    {
      Name  = "${var.project}-${var.environment}-database-${each.key}",
      scope = "database"
    },
    local.tags
  )
}

resource "aws_route_table" "expose_database" {
  count = var.expose_database ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = "${var.project}-${var.environment}-database",
      scope  = "database",
    },
    local.tags
  )
}

resource "aws_route_table_association" "expose_database" {
  for_each = var.expose_database ? aws_subnet.database : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.expose_database[0].id
}

resource "aws_route" "expose_database" {
  count = var.expose_database ? 1 : 0

  route_table_id         = aws_route_table.expose_database[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}
