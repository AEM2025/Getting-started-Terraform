output "ec2-public-ip" {
  value       = aws_instance.apache-instance1.public_ip
}

