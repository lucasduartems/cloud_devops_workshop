# ===== VPC ==================================================================

resource "aws_vpc" "this" {
  cidr_block = var.vpc.cidr_block

  tags = {
    Name = var.vpc.name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.vpc.internet_gateway_name
  }
}

# ===== Public Subnets =======================================================

resource "aws_subnet" "public" {
  count = length(var.vpc.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.vpc.public_subnets[count.index].cidr_block
  availability_zone       = var.vpc.public_subnets[count.index].availability_zone
  map_public_ip_on_launch = var.vpc.public_subnets[count.index].map_public_ip_on_launch

  tags = {
    Name = var.vpc.public_subnets[count.index].name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id  # Internet Gateway
  }

  tags = {
    Name = var.vpc.public_route_table_name
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ===== Private Subnets ======================================================

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = var.vpc.nat_gateway_name
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = var.vpc.nat_gateway_name
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}

resource "aws_subnet" "private" {
  count = length(var.vpc.private_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.vpc.private_subnets[count.index].cidr_block
  availability_zone       = var.vpc.private_subnets[count.index].availability_zone

  tags = {
    Name = var.vpc.private_subnets[count.index].name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id  # NAT Gateway
  }

  tags = {
    Name = var.vpc.private_route_table_name
  }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}