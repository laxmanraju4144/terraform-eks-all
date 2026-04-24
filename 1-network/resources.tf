# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, {
    Name = "${var.project}-vpc"
  })
}

# -----------------------------
# Internet Gateway (for public subnets)
# -----------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name = "${var.project}-igw"
  })
}

# -----------------------------
# Public Subnets (for ALB, NAT)
# -----------------------------
resource "aws_subnet" "public" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.this.id
  availability_zone       = local.azs[count.index]
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index) # e.g. 10.0.0.0/24, 10.0.1.0/24
  map_public_ip_on_launch = true

  tags = merge(local.tags, {
    Name                                   = "${var.project}-public-${local.azs[count.index]}"
    "kubernetes.io/role/elb"               = "1"
    "kubernetes.io/cluster/${var.project}" = "shared"
  })
}

# -----------------------------
# Private Subnets (for EKS nodes)
# -----------------------------
resource "aws_subnet" "private" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.this.id
  availability_zone       = local.azs[count.index]
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 10) # e.g. 10.0.10.0/24, 10.0.11.0/24
  map_public_ip_on_launch = false

  tags = merge(local.tags, {
    Name                                   = "${var.project}-private-${local.azs[count.index]}"
    "kubernetes.io/role/internal-elb"      = "1"
    "kubernetes.io/cluster/${var.project}" = "shared"
  })
}

# -----------------------------
# Public Route Table + Internet Route
# -----------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name = "${var.project}-public-rt"
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# -----------------------------
# NAT Gateway (for private subnets)
# -----------------------------
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(local.tags, {
    Name = "${var.project}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(local.tags, {
    Name = "${var.project}-nat"
  })

  depends_on = [aws_internet_gateway.this]
}

# -----------------------------
# Private Route Table + NAT Route
# -----------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.tags, {
    Name = "${var.project}-private-rt"
  })
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

