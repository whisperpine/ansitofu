terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27.0"
    }
  }
}

# ----------- #
# Data blocks
# ----------- #

# Use it to check if the instance-type is valid.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type_offerings
data "aws_ec2_instance_type_offerings" "default" {
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }
}

# ------------ #
# EC2 instance
# ------------ #

# Define the EC2 instance.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "default" {
  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu_24_04.id
  subnet_id     = data.aws_subnet.default.id
  key_name      = aws_key_pair.default.key_name
  # Add a security group to allow SSH access.
  vpc_security_group_ids = [var.security_group_id]
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }
  metadata_options {
    http_tokens = "required"
  }
  lifecycle {
    # Check if the assigned instance_type is valid.
    precondition {
      condition     = length(data.aws_ec2_instance_type_offerings.default.instance_types) > 0
      error_message = "the ec2 instance type '${var.instance_type}' isn't supported"
    }
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
