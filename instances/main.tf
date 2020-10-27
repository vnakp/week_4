
provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc_eng" {
  cidr_block           = var.cidr_vpc_eng
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw_eng" {
  vpc_id = aws_vpc.vpc_eng.id
}

resource "aws_subnet" "graf_subnet_public" {
  vpc_id     = aws_vpc.vpc_eng.id
  cidr_block = var.cidr_subnet_graf
}

resource "aws_subnet" "prom_subnet_private" {
  vpc_id     = aws_vpc.vpc_eng.id
  cidr_block = var.cidr_subnet_prom
}

resource "aws_route_table" "graf_rtb_public" {
  vpc_id = aws_vpc.vpc_eng.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_eng.id
  }
}

resource "aws_route_table_association" "rta_graf_subnet_public" {
  subnet_id      = aws_subnet.graf_subnet_public.id
  route_table_id = aws_route_table.graf_rtb_public.id
}

resource "aws_security_group" "sg_22_9090" {
  name   = "sg_9090"
  vpc_id = aws_vpc.vpc_eng.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "sg_22_3000" {
  name   = "sg_3000"
  vpc_id = aws_vpc.vpc_eng.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "prom" {
  ami                         = "ami-01ec800683a0e9cfd"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.prom_subnet_private.id
  vpc_security_group_ids      = [aws_security_group.sg_22_9090.id]
  associate_public_ip_address = true

  tags = {
    Name = "Promsvr1"
  }
}

resource "aws_instance" "graf" {
  ami                         = "ami-0088561aa79641e80"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.graf_subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_22_3000.id]
  associate_public_ip_address = true

  tags = {
    Name = "Grafsvr1"
  }
}
output "id" {
  value = aws_instance.prom.public_ip
}

output "id_2" {
  value = aws_instance.graf.public_ip
}
