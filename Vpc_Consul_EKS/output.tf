
output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

# output "kubectl_config" {
#   description = "kubectl config as generated by the module."
#   value       = module.eks.kubeconfig
# }

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.config_map_aws_auth
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}


output "consul-server_public_address" {
    value = aws_instance.server.*.public_ip
}

output "jenkins_server_public_addresses" {
    value = aws_instance.jenkins_server.*.public_ip
}

output "jenkins_slaves_public" {
    value = aws_instance.jenkins_slaves.*.public_ip
}

output "consul-server_private_address" {
    value = aws_instance.server.*.private_ip
}

output "jenkins_server_private" {
    value = aws_instance.jenkins_server.*.private_ip
}
output "jenkins_slaves_private" {
    value = aws_instance.jenkins_slaves.*.private_ip
}

####################################################################

