resource "aws_subnet" "common_public" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "lab-common-public"
  }
}

resource "aws_subnet" "dev_private" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "lab-dev-private"
  }
}
