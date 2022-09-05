output "eks_host" {
  value = module.eks.cluster_endpoint
}

output "eks_ca" {
  sensitive = true
  value     = module.eks.cluster_certificate_authority_data
}

output "eks_id" {
  value = module.eks.cluster_id
}

output "eks_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}
