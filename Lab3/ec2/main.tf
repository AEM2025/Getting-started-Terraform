# security group
resource "aws_security_group" "allow_http_ssh" {
  description = "Allow http and ssh inbound traffic"
  vpc_id = var.my_vpc_id # ------------------------------------ input here
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

# get ami of ubuntu
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = [var.ec2_ami_filter]
    }
    owners = [var.ec2_ami_owner]
}


# ec2 instance - public
resource "aws_instance" "nginx-instance1" {
    count = 2
    ami = data.aws_ami.ubuntu.id
    instance_type = var.ec2_type
    subnet_id = var.my_subnets_ids[count.index]# ------------------------------------ input here
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
    provisioner "local-exec" {
        command = "echo public-ip ${count.index + 1} ${self.public_ip} >> ./all-ips.txt"
    }
    connection {
        type     = "ssh"
        private_key = file("./${var.key_name}.pem")
        user     = "ubuntu"
        host     = self.public_ip
     }

    provisioner "remote-exec" {
     inline = [
        
        "sudo apt-get update",
        "sudo apt-get -y install nginx",
        "sudo systemctl start nginx", 
        "sudo systemctl enable nginx", 
        "sudo sed -i '52 i proxy_pass http://${var.private_lb_dns};'  /etc/nginx/sites-available/default",
        "sudo echo \"Hello world $(hostname -f)\" > /var/www/html/index.nginx-debian.html",
        "sudo systemctl restart nginx"
     ]
    
    
    
    }

    tags = {
        Name="pub-nginx-instance-${count.index + 1}"
    }
}

# ec2 instance - private
resource "aws_instance" "apache-instance2" {
    count = 2
    ami = data.aws_ami.ubuntu.id
    instance_type = var.ec2_type
    subnet_id = var.my_subnets_ids[count.index + 2] # ------------------------------------ input here
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
    provisioner "local-exec" {
        command = "echo private-ip ${count.index + 2} ${self.private_ip} >> ./all-ips.txt"
    }

    user_data = "${file("install_apache.sh")}"
    
    tags = {
        Name="private-apache-instance-${count.index + 1}"
    }
}

