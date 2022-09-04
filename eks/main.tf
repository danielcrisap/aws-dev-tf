module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = var.env
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

  vpc_id     = var.vpc_id
  subnet_ids = var.vpc_k8s_subnets_ids

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }


  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t2.micro", "t3.micro", "t3a.micro"]
  }

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 4
      desired_size = 1

      disk_size = 20
      #      capacity_type = "SPOT"

      use_name_prefix                 = false
      iam_role_use_name_prefix        = false
      launch_template_use_name_prefix = false

      ebs_optimized        = true
      force_update_version = true
    }
  }


  # aws-auth configmap
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::875201320882:role/AWSReservedSSO_AdministratorAccess_f8bbe6eb5ffc9f8c"
      username = "sso-admin:{{SessionName}}"
      groups   = ["system:masters"]
    },
  ]

  create_kms_key = true

  cluster_encryption_config = [
    {
      resources = ["secrets"]
    }
  ]

  cluster_tags = {
    Name = var.env
  }
  tags = local.tags

}
