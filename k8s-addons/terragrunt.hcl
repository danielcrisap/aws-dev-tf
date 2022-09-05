locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))

  env    = local.common_vars.env
  region = local.common_vars.aws_region
}

include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../eks"
}

inputs = {
  env                 = local.env
  region              = local.region
  eks_ca              = dependency.eks.outputs.eks_ca
  eks_host            = dependency.eks.outputs.eks_host
  eks_id              = dependency.eks.outputs.eks_id
  eks_oidc_issuer_url = dependency.eks.outputs.eks_oidc_issuer_url
}
