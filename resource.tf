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

# Define Elastic IP resource
resource "aws_eip" "eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.gw]
  lifecycle {
    create_before_destroy = true
  }
}

# Define EC2 instance resource
resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [var.security_group_id]
  subnet_id     = "${var.vpc_id}"
  associate_public_ip_address = true
  tags = {
    Name = var.instance_name
  }

  # Attach Elastic IP to the instance
  network_interface {
    device_index = 0

    # Use the Elastic IP created above
    network_interface_id = aws_network_interface.primary_interface.id
  }
}

# Attach Elastic IP to the network interface
resource "aws_network_interface" "primary_interface" {
  subnet_id       = var.vpc_id
  security_groups = [var.security_group_id]

  # Assign the Elastic IP to this network interface
  associate_public_ip_address = true
  depends_on = [aws_eip.eip]
  lifecycle {
    create_before_destroy = true
  }

  # Use the Elastic IP created above
  private_ips = [aws_eip.eip.public_ip]
}
