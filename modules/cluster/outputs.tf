output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_oidc_provider" {
  description = "OIDC provider for this EKS cluster"
  value       = module.eks.oidc_provider
}

output "cluster_certificate_authority_data" {
  description = "CA Data for EKS Cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_token" {
  description = "CA Data for EKS Cluster"
  value       = data.aws_eks_cluster_auth.cluster.token
  sensitive   = true
}

output "image_repository_url" {
  description = "URL of ECR image repository"
  value       = aws_ecr_repository.image_repository.repository_url
}
