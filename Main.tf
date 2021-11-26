#VPC
resource "aws_vpc" "ZooVPC" {
  cidr_block       = "192.168.0.0/16" 
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "ZooVPC"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.ZooVPC.id
  
  tags = {
    Name = "mainIGW"
  }
}

#PUBLIC (for the NAT) routing table 
resource "aws_route_table" "MainRT" {
  vpc_id = aws_vpc.ZooVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "MainRT"
  }
}


#PUBLIC-Subnet
resource "aws_subnet" "PublicSubnet1A" {
  availability_zone = "eu-west-1a"
  cidr_block = "192.168.11.0/24"
  vpc_id = aws_vpc.ZooVPC.id
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

# Elastic IP ADDRESSES
resource "aws_eip" "NAT_A_eip" {
  vpc      = true
}

# PUBLIC NAT GATEWAYS
resource "aws_nat_gateway" "NAT_A" {
  allocation_id = aws_eip.NAT_A_eip.id
  subnet_id     = aws_subnet.PublicSubnet1A.id

  tags = {
    Name = "NATGW PublicSubnetA"
  }

  depends_on = [aws_internet_gateway.IGW]
}

resource "aws_route_table_association" "Public1A" {
  subnet_id      = aws_subnet.PublicSubnet1A.id
  route_table_id = aws_route_table.MainRT.id
}

#PRIVATE-Subnet
resource "aws_subnet" "PrivateSubnet1A" {
  availability_zone = "eu-west-1a"
  cidr_block = "192.168.21.0/24"
  vpc_id = aws_vpc.ZooVPC.id

  tags = {
    Name = "PrivateSubnet"
  }
}

#Private routing table 
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.ZooVPC.id

  route {
    cidr_block = "192.168.21.0/24"
    gateway_id = aws_nat_gateway.NAT_A.id
  }

  tags = {
    Name = "PrivateRT"
  }
}

resource "aws_route_table_association" "Private1a" {
  subnet_id      = aws_subnet.PrivateSubnet1A.id
  route_table_id = aws_route_table.PrivateRT.id
}




# SecurityGroup to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.ZooVPC.id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_web"
  }
}

resource "aws_instance" "Public-ssh-Server" {
  ami               = "ami-09ce2fc392a4c0fbc"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  key_name          = "public_key"
  subnet_id     = aws_subnet.PublicSubnet1A.id
  vpc_security_group_ids = ["sg-01c19772c6464b563"]
  
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
  tags = {
    Name = "Public-ssh-Server"
  }
}

resource "aws_instance" "Shane" {
  ami               = "ami-09ce2fc392a4c0fbc"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  key_name          = "zoo-VPC"
  subnet_id     = aws_subnet.PrivateSubnet1A.id
  vpc_security_group_ids = ["sg-01c19772c6464b563"]
  
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
  tags = {
    Name = "Shane"
  }
}


resource "aws_instance" "Victor" {
  ami               = "ami-09ce2fc392a4c0fbc"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  key_name          = "zoo-VPC"
  subnet_id     = aws_subnet.PrivateSubnet1A.id
  vpc_security_group_ids = ["sg-01c19772c6464b563"]
  
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
  tags = {
    Name = "Victor"
  }
}

resource "aws_instance" "Selene" {
  ami               = "ami-09ce2fc392a4c0fbc"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  key_name          = "zoo-VPC"
  subnet_id     = aws_subnet.PrivateSubnet1A.id
  vpc_security_group_ids = ["sg-01c19772c6464b563"]
  
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
  tags = {
    Name = "Selene"
  }
}

resource "aws_instance" "Courtney" {
  ami               = "ami-09ce2fc392a4c0fbc"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  key_name          = "zoo-VPC"
  subnet_id     = aws_subnet.PrivateSubnet1A.id
  vpc_security_group_ids = ["sg-01c19772c6464b563"]
  
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
  tags = {
    Name = "Courtney"
  }
}