#--------#
# Subnet #
#--------#

locals {
  # Map subnets to availability zones
  public_subnets_az_with_cidr = { for az in var.azs : az => element(var.public_subnets_cidr, index(var.azs, az)) }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets_az_with_cidr

  vpc_id            = local.vpc_id
  availability_zone = each.key
  cidr_block        = each.value

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-public-${each.key}",
      scope  = "public",
      "kubernetes.io/role/elb" = 1
    },
    local.tags
  )
}

#------------------#
# Internet Gateway #
#------------------#

resource "aws_internet_gateway" "public" {
  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = "${var.project}-${var.environment}",
      scope  = "public",
    },
    local.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = "${var.project}-${var.environment}-public",
      scope  = "public",
    },
    local.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

#-------------#
# NAT Gateway #
#-------------#

locals {
  # List of NATs to create
  nat_gateways = toset(var.one_nat_gateway_per_az ? var.azs : ["single"])
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateways

  vpc = true

  tags = merge(
    {
      "Name" = "${var.project}-${var.environment}-nat-${each.key}",
      scope  = "public",
    },
    local.tags
  )
}

resource "aws_nat_gateway" "public" {
  for_each   = local.nat_gateways
  depends_on = [aws_internet_gateway.public]

  subnet_id     = try(aws_subnet.public[each.key].id, aws_subnet.public[var.azs[0]].id)
  allocation_id = aws_eip.nat[each.key].id

  tags = merge(
    {
      "Name" = "${var.project}-${var.environment}-${each.key}",
      scope  = "public",
    },
    local.tags
  )
}
