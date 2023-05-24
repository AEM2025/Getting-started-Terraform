# VPC 10.0.0.0/16
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "my-vpc"
    }
}

# Subnet --> public 10.0.0.0/24
resource "aws_subnet" "subnet" {
    count = length(var.subnet_cidr_block)
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_cidr_block[count.index]
    availability_zone = var.az_names[count.index]
    map_public_ip_on_launch = var.public_ip[count.index]
    tags = {
        Name = "subnet-1"
    }
}

/* Subnet --> private 10.0.1.0/24
resource "aws_subnet" "private-subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_cidr_block[1]
    availability_zone = var.az_names[1]
    tags = {
        Name = "private-subnet-1"
    }
}*/



# internet gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "my-igw-1"
    }

}

resource "aws_eip" "nateIP" {
    vpc = true
}

resource "aws_nat_gateway" "NATgw" {
    allocation_id = aws_eip.nateIP.id
    subnet_id = aws_subnet.subnet[0].id # --------------- here's the error must be in public subnet not private
}

# route table , 0.0.0.0/0 
resource "aws_route_table" "publicRT" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = var.RT_cidr_block
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name="my-public-route-table"
    }
}


# route table , 0.0.0.0/0
resource "aws_route_table" "privateRT" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = var.RT_cidr_block
        gateway_id = aws_nat_gateway.NATgw.id
    }
    tags = {
        Name="my-private-route-table"
    }
}



# Route table associations for both Public Subnet
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.subnet[0].id
    route_table_id = aws_route_table.publicRT.id
}



# Route table associations for both private Subnet
resource "aws_route_table_association" "private" {
    subnet_id      = aws_subnet.subnet[1].id
    route_table_id = aws_route_table.privateRT.id
}





# security group
resource "aws_security_group" "allow_http_ssh" {
  description = "Allow http and ssh inbound traffic"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-security-group"
  }
 
    ingress {
    from_port   = var.sg-ports[0]
    to_port     = var.sg-ports[0]
    protocol    = "tcp"
    cidr_blocks = [var.RT_cidr_block]
  }

    ingress {
    from_port   = var.sg-ports[1]
    to_port     = var.sg-ports[1]
    protocol    = "tcp"
    cidr_blocks = [var.RT_cidr_block]
  }

  egress {
    from_port       = var.sg-ports[2]
    to_port         = var.sg-ports[2]
    protocol        = "-1"
    cidr_blocks     = [var.RT_cidr_block]
  }
}

# ec2 instance
resource "aws_instance" "apache-instance1" {
    ami = var.ec2_ami
    instance_type = var.ec2_type
    subnet_id = aws_subnet.subnet[0].id
    vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
    user_data = "${file("install_apache.sh")}"
    tags = {
        Name="public-apache-instance-1"
    }
}

# ec2 instance
resource "aws_instance" "apache-instance2" {
    ami = var.ec2_ami
    instance_type = var.ec2_type
    subnet_id = aws_subnet.subnet[1].id

    key_name = aws_key_pair.key_pair.key_name


    vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
    user_data = "${file("install_apache.sh")}"
    tags = {
        Name="private-apache-instance-2"
    }
}





# Below Code will generate a secure private key with encoding
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "linux-key-pair"  
  public_key = tls_private_key.key_pair.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}