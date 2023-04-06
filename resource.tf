provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.medium"

  tags = {
    Name = "K8s cluster"
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.example.id
  }
}

resource "aws_network_interface" "example" {
  subnet_id       = "subnet-05a31b67b18113593"
  security_groups = ["sg-09947aa36d4d8ebb2"]
  depends_on      = [aws_internet_gateway.gw]
  attachment {
    instance = aws_instance.example.id
  }
}

resource "aws_eip" "example" {
  vpc      = true
  public_ip = "44.213.206.125"
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "vpc-04015f3645142a1fa"
}

resource "aws_route_table_association" "example" {
  subnet_id      = "subnet-05a31b67b18113593"
  route_table_id = "rtb-0c98e4ab437db89e0"
}
