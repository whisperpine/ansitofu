variable "subnet_id" {
  description = "the subnet id which will be assigned to all ec2 instances"
  type        = string
}

variable "security_group_id" {
  description = "the security group id which will be assigned to all ec2 instances"
  type        = string
}

variable "ssh_public_key" {
  description = "the public ssh key to be used in aws_key_pair"
  type        = string
}
