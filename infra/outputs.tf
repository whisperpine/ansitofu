# --------------- #
# module: aws_ec2
# --------------- #

output "public_ips" {
  description = "a list of AWS Elastic IPs"
  value       = [for o in module.aws_ec2 : o.public_ip]
  sensitive   = true
}
