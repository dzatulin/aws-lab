# Internet Gateway for Common VPC

resource "aws_internet_gateway" "common" {
  vpc_id = aws_vpc.common.id

  tags = {
    Name = "lab-common-igw"
  }
}

# Route Tables
# VPN return route 172.27.100.0/24 is managed outside Terraform by the
# Pritunl host (CloudTrail: lab-common-ec2-ssm, CreateRoute on 2026-11-21).
# Keep routes as standalone aws_route resources. Do not add an inline route
# list or a duplicate VPN aws_route without an explicit ownership migration.

resource "aws_route_table" "common_public" {
  vpc_id = aws_vpc.common.id

  tags = {
    Name = "lab-common-public-rt"
  }
}

resource "aws_route_table" "dev_private" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "lab-dev-private-rt"
  }
}

# Common VPC -> Internet

resource "aws_route" "common_internet" {
  route_table_id         = aws_route_table.common_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.common.id
}

# Common VPC -> DEV VPC

resource "aws_route" "common_to_dev" {
  route_table_id            = aws_route_table.common_public.id
  destination_cidr_block    = aws_vpc.dev.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.common_dev.id
}

# DEV VPC -> Common VPC

resource "aws_route" "dev_to_common" {
  route_table_id            = aws_route_table.dev_private.id
  destination_cidr_block    = aws_vpc.common.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.common_dev.id
}

# Associate Route Tables with Subnets

resource "aws_route_table_association" "common_public" {
  subnet_id      = aws_subnet.common_public.id
  route_table_id = aws_route_table.common_public.id
}

resource "aws_route_table_association" "dev_private" {
  subnet_id      = aws_subnet.dev_private.id
  route_table_id = aws_route_table.dev_private.id
}
