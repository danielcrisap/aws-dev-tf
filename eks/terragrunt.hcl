include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  env                 = include.root.locals.env
  region              = include.root.locals.aws_region
  vpc_id              = dependency.vpc.outputs.vpc_id
  vpc_k8s_subnets_ids = dependency.vpc.outputs.k8s_private_subnets
}
