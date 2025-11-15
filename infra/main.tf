# sops_file data docs:
# https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file
data "sops_file" "default" {
  source_file = "encrypted.${terraform.workspace}.json"
}

locals {
  # tags for hashicorp/aws provider
  repository = "ansitofu"
  default_tags = {
    tf-workspace  = terraform.workspace
    tf-repository = local.repository
  }
  # provider: hashicorp/aws 
  aws_provider_region   = data.sops_file.default.data["aws_provider_region"]
  aws_access_key_id     = data.sops_file.default.data["aws_access_key_id"]
  aws_secret_access_key = data.sops_file.default.data["aws_secret_access_key"]
}

# Create commonly used aws resources (e.g. aws resource group).
module "aws_common" {
  source                  = "./aws-common"
  aws_resource_group_name = "${local.repository}-${terraform.workspace}"
  default_tags            = local.default_tags
}

# Create AWS VPC relevant resources (e.g. Subnet, Security Groups).
module "aws_vpc" {
  source             = "./aws-vpc"
  cidr_block         = "10.0.0.0/16"
  public_subnets     = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  availability_zones = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

# Create aws EC2 instances and auxiliary resources.
module "aws_ec2" {
  source            = "./aws-ec2"
  subnet_id         = each.value
  security_group_id = module.aws_vpc.security_group_id
  ssh_public_key    = file("./id_ed25519.pub")
  # Create one EC2 instance for each public subnet.
  for_each = toset(module.aws_vpc.public_subnet_ids)
}
