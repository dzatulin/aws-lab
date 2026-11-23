resource "aws_eip" "pritunl" {
  domain   = "vpc"
  instance = aws_instance.pritunl.id

  tags = {
    Name    = "lab-pritunl-eip"
    Project = "aws-lab"
  }
}
