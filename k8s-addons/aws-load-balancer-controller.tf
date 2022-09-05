module "aws-load-balancer-controller" {
  source  = "cloudposse/helm-release/aws"
  version = "0.6.0"

  name = "aws-load-balancer-controller"

  repository    = "https://aws.github.io/eks-charts/"
  chart         = "aws-load-balancer-controller"
  chart_version = "0.19.2"

  atomic               = true
  cleanup_on_fail      = true
  timeout              = 300
  wait                 = true
  kubernetes_namespace = "aws-lb-controller"
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url

  values = [
    file("${path.module}/aws-load-balancer-controller-values.yaml")
  ]
}
