# ---- networking/main.tf
data "aws_availability_zones" "available" {}

resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets

}
resource "random_integer" "random" {
  min = 1
  max = 100

}



resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mtc-vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = random_shuffle.az.result[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "mtc-public-${count.index + 1}"
  }

}

resource "aws_route_table_association" "mtc-public-assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.mtc-public-rt.id

}

resource "aws_subnet" "private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_cidrs[count.index]
  availability_zone       = random_shuffle.az.result[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "mtc-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "mtc-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "mtc-igw"
  }

}

resource "aws_route_table" "mtc-public-rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "mtc-public"
  }
}

resource "aws_route" "default-route" {
  route_table_id         = aws_route_table.mtc-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc-igw.id
}

resource "aws_default_route_table" "mtc-private-rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = {
    "Name" = "mtc-default-private"
  }

}

resource "aws_security_group" "mtc-sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.vpc.id
  tags        = each.value.tags

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port_in
      to_port     = ingress.value.to_port_in
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}

resource "aws_db_subnet_group" "mtc-rds-subnet-group" {
  count      = var.db_subnet_group == true ? 1 : 0
  name       = "mtc-rds-subnet-group"
  subnet_ids = aws_subnet.private_subnet.*.id
  tags = {
    "Name" = "mtc-rds-subnet-group"
  }


}