output "subnet_id" {
  description = "the id of the default subnet"
  value       = aws_subnet.default.id
}

output "security_group_id" {
  description = "the id of the security group"
  value       = aws_security_group.allow_ssh.id
}
