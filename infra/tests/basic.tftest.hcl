# carlpett/sops provider docs: 
# https://registry.terraform.io/providers/carlpett/sops/latest/docs
provider "sops" {}

# hashicorp/aws provider docs:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region     = local.aws_provider_region
  access_key = local.aws_access_key_id
  secret_key = local.aws_secret_access_key
  default_tags {
    tags = local.default_tags
  }
}

# Test the root module (plan).
run "test_root_module" {
  command = plan
  assert {
    condition     = length(module.aws_ec2[*]) == length(module.aws_vpc.public_subnet_ids)
    error_message = "the number of module.aws_ec2 isn't equal to the number of subnets"
  }
}
