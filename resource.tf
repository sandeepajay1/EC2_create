# Define variables
variable "aws_region" {
  default = "us-east-1"
}
variable "instance_name" {
  default = "testServer"
}
variable "key_name" {
  default = "Udemy"
}
variable "security_group_id" {
  default = "sg-09947aa36d4d8ebb2"
}
variable "vpc_id" {
  default = "subnet-05a31b67b18113593"
}
variable "instance_type" {
  default = "t2.medium"
}
variable "ami_id" {
  default = "ami-007855ac798b5175e"
}

# Define elastic IP resource
resource "aws_eip" "eip" {
  vpc = true
}

# Define EC2 instance resource
resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [var.security_group_id]
  subnet_id     = "${var.vpc_id}"
  tags = {
    Name = var.instance_name
  }

  # Associate elastic IP with instance
  network_interface {
    network_interface_id = aws_network_interface.primary_interface.id
    device_index         = 0
  }

  depends_on = [aws_eip.eip]
}

# Define network interface resource
resource "aws_network_interface" "primary_interface" {
  subnet_id = var.vpc_id

  # Associate elastic IP with network interface
  associate_public_ip_address = true

  depends_on = [aws_eip.eip]
}
