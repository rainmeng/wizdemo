resource "aws_eip" "demo" {

  count = var.enable_public_ip ? 1 : 0

  domain = "vpc"

  tags = {
    Name = "${var.instance_name}-eip"
  }
}

resource "aws_eip_association" "demo" {

  count = var.enable_public_ip ? 1 : 0

  instance_id   = aws_instance.demo.id
  allocation_id = aws_eip.demo[0].id
}
