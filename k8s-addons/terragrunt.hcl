include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "eks" {
  config_path = "../eks"
}

inputs = {
  env                 = include.root.locals.env
  region              = include.root.locals.aws_region
  eks_ca              = dependency.eks.outputs.eks_ca
  eks_host            = dependency.eks.outputs.eks_host
  eks_id              = dependency.eks.outputs.eks_id
  eks_oidc_issuer_url = dependency.eks.outputs.eks_oidc_issuer_url
}
