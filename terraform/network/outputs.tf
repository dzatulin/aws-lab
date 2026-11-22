output "common_public_subnet_id" {
  value = aws_subnet.common_public.id
}

output "common_test_sg_id" {
  value = aws_security_group.common_test.id
}

output "dev_private_subnet_id" {
  description = "Private subnet ID in Dev VPC"
  value       = aws_subnet.dev_private.id
}

output "dev_security_group_id" {
  description = "Security Group ID for Dev EC2"
  value       = aws_security_group.dev_test.id
}

output "common_probe_security_group_id" {
  value = aws_security_group.common_probe.id
}
