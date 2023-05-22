module "aws-node-termination-handler" {
  source  = "cloudposse/helm-release/aws"
  version = "0.8.1"

  name = "aws-node-termination-handler"

  repository    = "https://aws.github.io/eks-charts/"
  chart         = "aws-node-termination-handler"
  chart_version = "0.19.2"

  atomic               = true
  cleanup_on_fail      = true
  timeout              = 300
  wait                 = true
  kubernetes_namespace = "kube-system"
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url

  values = [
    file("${path.module}/aws-node-termination-handler-values.yaml")
  ]
}
