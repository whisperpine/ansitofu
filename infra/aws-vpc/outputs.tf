output "subnet_id" {
  description = "the id of the default subnet"
  value       = aws_subnet.default.id
}

output "security_group_id" {
  description = "the id of the security group"
  value       = aws_default_security_group.default.id
}
