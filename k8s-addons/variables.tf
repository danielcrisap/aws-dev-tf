variable "region" {}
variable "env" {}
variable "eks_ca" {}
variable "eks_host" {}
variable "eks_id" {}
variable "eks_oidc_issuer_url" {}

locals {
  tags = {
    Terraform = "true"
    Environment = var.env
  }
}
