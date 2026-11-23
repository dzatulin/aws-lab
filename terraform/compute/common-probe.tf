resource "aws_instance" "common_probe" {
  ami           = aws_instance.pritunl.ami
  instance_type = "t3.micro"

  subnet_id = data.terraform_remote_state.network.outputs.common_public_subnet_id

  vpc_security_group_ids = [
    data.terraform_remote_state.network.outputs.common_probe_security_group_id
  ]

  associate_public_ip_address = false

  user_data                   = file("${path.module}/templates/common-probe.sh")
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name        = "lab-common-probe"
    Environment = "lab"
    Project     = "aws-lab"
  }
}
