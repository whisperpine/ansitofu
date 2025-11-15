output "public_subnet_ids" {
  description = "the id of the default subnet"
  value       = [for o in aws_subnet.public : o.id]
}

output "security_group_id" {
  description = "the id of the security group"
  value       = aws_default_security_group.default.id
}
