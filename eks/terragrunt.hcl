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

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-eks.git//.?ref=v18.29.0"
}

inputs = {
  cluster_name    = local.common_vars.env
  cluster_version = "1.23"

  cluster_enabled_log_types       = []
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy         = {}
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.k8s_private_subnets

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = "t2.micro"
    update_launch_template_default_version = true
    iam_role_additional_policies           = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::875201320882:role/AWSReservedSSO_AdministratorAccess_f8bbe6eb5ffc9f8c"
      username = "admin"
      groups   = ["system:masters"]
    },
  ]

  create_kms_key = true
  
  cluster_encryption_config = [
    {
      resources = ["secrets"]
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}
