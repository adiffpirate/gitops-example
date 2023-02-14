locals {
  # Map subnets to availability zones
  private_subnets_az_with_cidr = { for az in var.azs : az => element(var.private_subnets_cidr, index(var.azs, az)) }
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets_az_with_cidr

  vpc_id            = local.vpc_id
  availability_zone = each.key
  cidr_block        = each.value

  tags = merge(
    {
      Name = "${var.name}-private-${each.key}",
      "kubernetes.io/role/internal-elb" = 1
    },
    local.tags
  )
}

# Create one route table for each NAT gateway
resource "aws_route_table" "private" {
  for_each = local.nat_gateways

  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.name}-private-${each.key}" },
    local.tags
  )
}

resource "aws_route" "private_nat_gateway" {
  for_each = local.nat_gateways

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public[each.key].id
}
