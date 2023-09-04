resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.vpc_dns_support
  enable_dns_hostnames = var.vpc_dns_hostnames
  tags = {
    Name = "${var.project_name}"
  }
}


# PUBLIC Subnet Resources

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Subnets in multiple AZs are necessary when using a load balancer,
# and therefore so are the dual subsequent resources
resource "aws_subnet" "public_first_az" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.first_public_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = var.map_public_ip
}

resource "aws_subnet" "public_second_az" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.second_public_cidr
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = var.map_public_ip
}

resource "aws_eip" "first_nat" {
  vpc = true
}

resource "aws_eip" "second_nat" {
  vpc = true
}

resource "aws_nat_gateway" "first_ngw" {
  subnet_id     = aws_subnet.public_first_az.id
  allocation_id = aws_eip.first_nat.id
  # Requires a resource dependency.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "second_ngw" {
  subnet_id     = aws_subnet.public_second_az.id
  allocation_id = aws_eip.second_nat.id
  # Requires a resource dependency.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "first_public" {
  subnet_id      = aws_subnet.public_first_az.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "second_public" {
  subnet_id      = aws_subnet.public_second_az.id
  route_table_id = aws_route_table.public.id
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl_rule" "public_ingress" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_egress" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}


# PRIVATE Subnet Resources

resource "aws_subnet" "private_first_az" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.first_private_cidr
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "private_second_az" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.second_private_cidr
  availability_zone = "${var.aws_region}c"
}

resource "aws_route_table" "first_private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "second_private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "first_private" {
  route_table_id         = aws_route_table.first_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.first_ngw.id
}

resource "aws_route" "second_private" {
  route_table_id         = aws_route_table.second_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.second_ngw.id
}

resource "aws_route_table_association" "first_private" {
  subnet_id      = aws_subnet.private_first_az.id
  route_table_id = aws_route_table.first_private.id
}

resource "aws_route_table_association" "second_private" {
  subnet_id      = aws_subnet.private_second_az.id
  route_table_id = aws_route_table.second_private.id
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl_rule" "private_ingress" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_egress" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "ECS security group for the ${var.project_name} ALB."
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 31000
    to_port   = 61000
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}