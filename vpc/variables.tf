variable "region" {}
variable "env" {}

locals {
  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
