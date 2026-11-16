resource "aws_security_group" "common_test" {
  name        = "lab-common-test"
  description = "Common VPC connectivity test"
  vpc_id      = aws_vpc.common.id

  tags = {
    Name = "lab-common-test"
  }
}

resource "aws_security_group" "dev_test" {
  name        = "lab-dev-test"
  description = "DEV VPC connectivity test"
  vpc_id      = aws_vpc.dev.id

  tags = {
    Name = "lab-dev-test"
  }
}

resource "aws_vpc_security_group_egress_rule" "common_to_dev" {
  security_group_id            = aws_security_group.common_test.id
  referenced_security_group_id = aws_security_group.dev_test.id

  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080

  depends_on = [aws_vpc_peering_connection.common_dev]
}

resource "aws_vpc_security_group_ingress_rule" "dev_from_common" {
  security_group_id            = aws_security_group.dev_test.id
  referenced_security_group_id = aws_security_group.common_test.id

  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080

  depends_on = [aws_vpc_peering_connection.common_dev]
}

resource "aws_vpc_security_group_egress_rule" "common_https" {
  security_group_id = aws_security_group.common_test.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "common_http" {
  security_group_id = aws_security_group.common_test.id

  description = "HTTP access to package repositories"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "pritunl_openvpn" {
  security_group_id = aws_security_group.common_test.id

  description = "OpenVPN access from trusted client"
  ip_protocol = "udp"
  from_port   = 19649
  to_port     = 19649

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "common_test_http" {
  security_group_id = aws_security_group.common_test.id

  description = "HTTP test from VPN clients"
  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080
  cidr_ipv4   = "172.27.100.0/24"
}
