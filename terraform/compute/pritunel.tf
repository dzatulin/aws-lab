resource "aws_instance" "pritunl" {
  ami           = var.pritunl_ami_id
  instance_type = "t3.micro"

  subnet_id = data.terraform_remote_state.network.outputs.common_public_subnet_id

  vpc_security_group_ids = [
    data.terraform_remote_state.network.outputs.common_test_sg_id
  ]

  user_data = templatefile(
    "${path.module}/templates/pritunl.sh.tftpl",
    {}
  )

  user_data_replace_on_change = true

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2.name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm
  ]

  tags = {
    Name = "lab-pritunl-ec2"
  }
}

output "pritunl_instance_id" {
  value = aws_instance.pritunl.id
}

output "pritunl_private_ip" {
  value = aws_instance.pritunl.private_ip
}

output "pritunl_public_ip" {
  value = aws_instance.pritunl.public_ip
}
