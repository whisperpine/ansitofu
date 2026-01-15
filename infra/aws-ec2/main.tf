terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27.0"
    }
  }
}

# Define the EC2 instance.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "default" {
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.default.key_name
  # Add a security group to allow SSH access.
  vpc_security_group_ids = [var.security_group_id]
  # Note: find AMI in AWS dashboard (try to create an EC2 instance).
  ami = "ami-0933f1385008d33c4" # Ubuntu, 24.04 LTS
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }
  metadata_options {
    http_tokens = "required"
  }
}

# Elastic IP.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "default" {
  instance = aws_instance.default.id
}

# Create a key pair in AWS using an existing public key.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "default" {
  public_key = var.ssh_public_key
}

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
# resource "aws_ebs_volume" "default" {
#   availability_zone = "ap-southeast-1c"
#   # Volume size in GiB.
#   size = 40
#   # Type of EBS volume (gp3, io2, st1).
#   type = "gp3"
# }
#
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment
# resource "aws_volume_attachment" "default" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.default.id
#   instance_id = aws_instance.default.id
# }
