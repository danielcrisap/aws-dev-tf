locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))

  env = local.common_vars.env
  region = local.common_vars.aws_region
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git//.?ref=v3.14.3"
}

inputs = {
  name = "${local.common_vars.env}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = local.env
  }
}
