# --------------------
# module: aws_ec2
# --------------------

output "public_ip" {
  description = "the public ip of the aws elastic ip"
  value       = module.aws_ec2.public_ip
  sensitive   = true
}
