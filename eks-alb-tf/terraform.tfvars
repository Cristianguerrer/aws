# Proyecto
project_name = "piloto-eks"
environment  = "dev"

# Región
aws_region = "us-east-1"

# EKS
cluster_name    = "piloto-eks-cluster"
cluster_version = "1.32"

# VPC
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]

# Nodos
node_group_instance_types = ["t3.micro", "t2.micro"]
node_group_desired_size   = 2
node_group_min_size       = 1
node_group_max_size       = 3
