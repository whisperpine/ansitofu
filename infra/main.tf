# https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file
data "sops_file" "default" {
  source_file = "encrypted.${terraform.workspace}.json"
}

locals {
  # Tags for hashicorp/aws provider.
  repository = "ansitofu"
  default_tags = {
    tf-workspace  = terraform.workspace
    tf-repository = local.repository
  }
  # Provider: hashicorp/aws.
  aws_provider_region   = data.sops_file.default.data["aws_provider_region"]
  aws_access_key_id     = data.sops_file.default.data["aws_access_key_id"]
  aws_secret_access_key = data.sops_file.default.data["aws_secret_access_key"]
  cidr_block            = "10.0.0.0/16"
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
  cidr_block         = local.cidr_block
  public_subnets     = cidrsubnets(local.cidr_block, 2, 2, 2)
  availability_zones = formatlist("${local.aws_provider_region}%s", ["a", "b", "c"])
}

# Create aws EC2 instances and auxiliary resources.
module "aws_ec2" {
  source            = "./aws-ec2"
  subnet_id         = module.aws_vpc.public_subnet_ids[count.index]
  security_group_id = module.aws_vpc.security_group_id
  ssh_public_key    = file("./id_ed25519.pub")
  # Create one EC2 instance for each public subnet.
  count = length(module.aws_vpc.public_subnet_ids)
}
