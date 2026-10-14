resource "aws_instance" "demo" {

  ami           = data.aws_ami.al2023.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  associate_public_ip_address = var.associate_public_ip_address

  vpc_security_group_ids = [
    aws_security_group.demo.id
  ]

  key_name = var.key_name

  tags = {
    Name = var.instance_name
  }
}
