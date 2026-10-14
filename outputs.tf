output "instance_id" {
  value = aws_instance.demo.id
}

output "private_ip" {
  value = aws_instance.demo.private_ip
}

output "public_ip" {
  value = try(aws_eip.demo[0].public_ip, null)
}
