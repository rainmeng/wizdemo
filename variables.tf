variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_name" {
  type    = string
  default = "public-ip-demo"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = null
}

variable "enable_public_ip" {
  type    = bool
  default = false
}

variable "associate_public_ip_address" {
  type = bool
  default = false
}
