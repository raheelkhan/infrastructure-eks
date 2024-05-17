output "image_repository_url" {
  description = "URL of ECR image repository"
  value       = module.cluster.image_repository_url
}

output "cluster_certificate_authority_data" {
  description = "CA Data for EKS Cluster"
  value       = module.cluster.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.cluster.cluster_endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.cluster.cluster_name
}
