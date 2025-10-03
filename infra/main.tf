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
