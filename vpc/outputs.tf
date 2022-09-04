output "vpc_id" {
  value = module.vpc.vpc_id
}

output "k8s_private_subnets" {
  description = "List of IDs of K8s subnets"
  value       = [for subnet in aws_subnet.k8s_extra_subnet : subnet.id]
}
