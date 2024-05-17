output "vpc_id" {
  description = "Unique identifier for VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets_ids" {
  description = "List of private subnet ids"
  value       = module.vpc.private_subnets
}


