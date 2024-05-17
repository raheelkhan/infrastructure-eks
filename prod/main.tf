module "network" {
  source = "../modules/network"

  vpc_name = var.vpc_name
}

module "cluster" {
  source = "../modules/cluster"

  region                       = var.region
  cluster_name                 = var.cluster_name
  vpc_id                       = module.network.vpc_id
  private_subnets_ids          = module.network.private_subnets_ids
  node_group_name              = var.node_group_name
  instance_types               = var.instance_types
  min_number_of_nodes          = var.min_number_of_nodes
  max_number_of_nodes          = var.max_number_of_nodes
  desired_number_of_nodes      = var.desired_number_of_nodes
  ebs_csi_role_name            = var.ebs_csi_role_name
  aws_alb_controller_role_name = var.aws_alb_controller_role_name
  image_repository_name        = var.image_repository_name
  github_oidc_role_arn         = var.github_oidc_role_arn

}
