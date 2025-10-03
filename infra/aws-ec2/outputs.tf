output "public_ip" {
  description = "the public ip of the aws elastic ip"
  value       = aws_eip.default.public_ip
}
