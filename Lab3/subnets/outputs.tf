output "my_subnets" {
  value       = aws_subnet.subnet[*].id
  description = "list of all avaliable subnets"
}
