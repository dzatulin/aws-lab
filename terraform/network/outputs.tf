output "common_public_subnet_id" {
  value = aws_subnet.common_public.id
}

output "common_test_sg_id" {
  value = aws_security_group.common_test.id
}
