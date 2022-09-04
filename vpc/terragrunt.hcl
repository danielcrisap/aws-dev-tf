locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))

  env = local.common_vars.env
  region = local.common_vars.aws_region
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  env = local.env
  region = local.region
}
