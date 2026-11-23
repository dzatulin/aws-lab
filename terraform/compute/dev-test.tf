resource "aws_instance" "dev_test" {
  ami           = aws_instance.pritunl.ami
  instance_type = "t3.micro"

  subnet_id = data.terraform_remote_state.network.outputs.dev_private_subnet_id

  vpc_security_group_ids = [
    data.terraform_remote_state.network.outputs.dev_security_group_id
  ]

  associate_public_ip_address = false

  user_data = file("${path.module}/templates/dev-http.sh")

  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name        = "lab-dev-test"
    Environment = "dev"
    Project     = "aws-lab"
  }
}
