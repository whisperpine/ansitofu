terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.15.0"
    }
  }
}

# --------------------
# VPC
# --------------------

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "default" {
  cidr_block = var.cidr_block
}

# --------------------
# Subnet
# --------------------

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.default.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.public_subnets[count.index]
  # Create one subnet for each availability zone.
  count = length(var.availability_zones)
}

# --------------------
# Network ACL
# --------------------

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
resource "aws_network_acl" "default" {
  vpc_id     = aws_vpc.default.id
  subnet_ids = [for o in aws_subnet.public : o.id]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
resource "aws_network_acl_rule" "inbound" {
  network_acl_id = aws_network_acl.default.id
  rule_number    = 200
  egress         = false # inbound
  protocol       = "-1"  # all protocol
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
resource "aws_network_acl_rule" "outbound" {
  network_acl_id = aws_network_acl.default.id
  rule_number    = 200
  egress         = true # outbound
  protocol       = "-1" # all protocol
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# --------------------
# Internet Gateway (IGW)
# --------------------

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# --------------------
# Route Table
# --------------------

# VPC's main Route Table.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table
resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.default.default_route_table_id
  route {
    cidr_block = var.cidr_block
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

# --------------------
# Security Group
# --------------------

# VPC's default Security Group.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.default.id
}

# Security group ingress rule.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  description       = "allow TCP traffic of port 22 (ssh connection)"
  security_group_id = aws_default_security_group.default.id
  cidr_ipv4         = "0.0.0.0/0" # Allows SSH from any IP (restrict for production).
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# Security group egress rule.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  description       = "allow all egress traffic"
  security_group_id = aws_default_security_group.default.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Semantically equivalent to all ports.
}
