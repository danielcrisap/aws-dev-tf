variable "region" {}
variable "env" {}
variable "vpc_id" {}
variable "vpc_k8s_subnets_ids" {
  type = list(string)
}

locals {
  tags = {
    Terraform = "true"
    Environment = var.env
  }
}
