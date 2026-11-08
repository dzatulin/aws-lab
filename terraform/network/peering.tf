resource "aws_vpc_peering_connection" "common_dev" {
  vpc_id      = aws_vpc.common.id
  peer_vpc_id = aws_vpc.dev.id
  auto_accept = true

  tags = {
    Name = "pritunl-common-to-dev"
  }
}
