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
variable "public_ip" {
  default = "44.213.206.125"
}

# Define EC2 instance resource
resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  security_groups        = [var.security_group_id]
  subnet_id              = "${var.vpc_id}"
  associate_public_ip_address = true
  tags = {
    Name = var.instance_name
  }
}

# Associate Elastic IP address
resource "aws_eip" "eip" {
  vpc                 = true
  instance            = aws_instance.ec2_instance.id
  associate_with_private_ip = aws_instance.ec2_instance.private_ip
  public_ip           = var.public_ip
}
