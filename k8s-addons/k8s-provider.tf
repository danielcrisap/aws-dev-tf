terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

locals {
  eks_cluster_oidc_issuer_url = replace(var.eks_oidc_issuer_url, "https://", "")
}

data "aws_eks_cluster_auth" "kubernetes" {
  name = var.eks_id
}

provider "helm" {
  kubernetes {
    host                   = var.eks_host
    cluster_ca_certificate = base64decode(var.eks_ca)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.eks_id]
    }
  }
}
