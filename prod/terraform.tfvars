region = "us-east-1"

vpc_name = "prod-eks-cluster-vpc"

cluster_name = "prod-cluster"

node_group_name = "prod-node-group"

instance_types = ["t3.small"]

min_number_of_nodes = 1

max_number_of_nodes = 1

desired_number_of_nodes = 1

ebs_csi_role_name = "ProdEBSCSIRole"

aws_alb_controller_role_name = "ProdAWSLoadBalancerControllerRole"

image_repository_name = "prod-image-repository"
