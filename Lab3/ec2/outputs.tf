output "my_sg" {
  value       = aws_security_group.allow_http_ssh.id
  description = "My security group"
}

output "Pub_instances_ids" {
  value       = aws_instance.nginx-instance1[*].id
}

output "Private_instances_ids" {
  value       = aws_instance.apache-instance2[*].id
}
