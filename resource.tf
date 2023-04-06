provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "k8s_cluster" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.medium"
  subnet_id     = "subnet-05a31b67b18113593"
  vpc_security_group_ids = [
    "sg-09947aa36d4d8ebb2"
  ]

  tags = {
    Name = "k8s_cluster"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.k8s_cluster.id
  allocation_id = "44.213.206.125"
}
