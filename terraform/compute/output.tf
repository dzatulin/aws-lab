output "pritunl_instance_id" {
  value = aws_instance.pritunl.id
}

output "pritunl_private_ip" {
  value = aws_instance.pritunl.private_ip
}

output "pritunl_public_ip" {
  value = aws_eip.pritunl.public_ip
}

output "dev_test_private_ip" {
  description = "Private IP of Dev test EC2"
  value       = aws_instance.dev_test.private_ip
}

output "common_probe_private_ip" {
  description = "Common VPC HTTP probe IP"
  value       = aws_instance.common_probe.private_ip
}
