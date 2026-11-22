resource "aws_security_group" "common_probe" {
  name        = "lab-common-probe"
  description = "HTTP source IP testing"
  vpc_id      = aws_subnet.common_public.vpc_id

  egress = []

  tags = {
    Name = "lab-common-probe"
  }
}

# NAT: traffic arrives from Pritunl EC2
resource "aws_vpc_security_group_ingress_rule" "common_probe_nat" {
  security_group_id = aws_security_group.common_probe.id

  referenced_security_group_id = aws_security_group.common_test.id

  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080

  description = "HTTP from Pritunl NAT"
}

# No-NAT: preserve original VPN client IP
resource "aws_vpc_security_group_ingress_rule" "common_probe_vpn" {
  security_group_id = aws_security_group.common_probe.id

  cidr_ipv4   = "172.27.100.0/24"
  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080

  description = "HTTP from VPN clients without NAT"
}

# Permit Pritunl to reach the test instance
resource "aws_vpc_security_group_egress_rule" "common_to_probe" {
  security_group_id = aws_security_group.common_test.id

  referenced_security_group_id = aws_security_group.common_probe.id

  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080

  description = "Pritunl to Common HTTP probe"
}
