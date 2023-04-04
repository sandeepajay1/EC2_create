# Define variables
variable "aws_region" {
  default = "us-east-1"
}

variable "instance_name" {
  default = "deploy to test"
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
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-00c39f71452c08778"
}

# Check if an instance with the same name and configuration already exists
data "aws_instances" "existing_instance" {
  instance_tags = {
    Name = var.instance_name
  }
  instance_state_names = ["running", "stopped"]
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }
  filter {
    name   = "image-id"
    values = [var.ami_id]
  }
}

# Define EC2 instance resource only if it does not already exist
resource "aws_instance" "ec2_instance" {
  count = length(data.aws_instances.existing_instance.ids) == 0 ? 1 : 0

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [var.security_group_id]
  subnet_id     = "${var.vpc_id}"
  tags = {
    Name = var.instance_name
  }
}
