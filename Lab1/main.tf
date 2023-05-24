provider "aws" {
    region = "us-east-1"
    shared_config_files = ["/home/aem/.aws/config"]
    shared_credentials_files = ["/home/aem/.aws/credentials"]
    profile = "default"
}


# VPC 10.0.0.0/16
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}


# Subnet --> public 10.0.0.0/24
resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "Pub-subnet-1"
    }
}


# internet gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "my-igw-1"
    }

}

# route table , 0.0.0.0/0 , ::/0
resource "aws_route_table" "public-route" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
  }
    tags = {
        Name="my-public-route-table"
    }
}

# Route table associations for both Public Subnet
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public-subnet.id
    route_table_id = aws_route_table.public-route.id
}


# security group
resource "aws_security_group" "allow_http_ssh" {
  description = "Allow http and ssh inbound traffic"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-security-group"
  }
 
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# ec2 instance
resource "aws_instance" "apache-instance" {
    ami = "ami-007855ac798b5175e"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-subnet.id
    vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
    # security_groups = [aws_security_group.allow_http_ssh.id] -------------------------------> Here's the problem: it will recreate the secruity group each time we run terraform apply. To solve it we should use: vpc_security_group_ids 
    user_data = "${file("install_apache.sh")}"
    tags = {
        Name="my-apache-instance"
    }
}


