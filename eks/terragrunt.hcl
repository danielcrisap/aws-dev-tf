locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))

  env    = local.common_vars.env
  region = local.common_vars.aws_region
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  env                 = local.env
  region              = local.region
  vpc_id              = dependency.vpc.outputs.vpc_id
  vpc_k8s_subnets_ids = dependency.vpc.outputs.k8s_private_subnets
}
