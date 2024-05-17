region = "us-east-1"

vpc_name = "stage-eks-cluster-vpc"

cluster_name = "stage-cluster"

node_group_name = "stage-node-group"

instance_types = ["t3.small"]

min_number_of_nodes = 1

max_number_of_nodes = 1

desired_number_of_nodes = 1

ebs_csi_role_name = "StageEBSCSIRole"

aws_alb_controller_role_name = "StageAWSLoadBalancerControllerRole"

image_repository_name = "stage-image-repository"
