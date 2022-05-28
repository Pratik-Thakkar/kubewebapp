output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.webapp-dev-eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.webapp-dev-eks.cluster_endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}