variable "aws_region" {
  description = "Región AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "piloto-eks"
}

variable "environment" {
  description = "Ambiente (dev/stage/prod)"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Nombre del cluster EKS"
  type        = string
  default     = "piloto-eks-cluster"
}

variable "cluster_version" {
  description = "Versión de Kubernetes para EKS (por ejemplo, 1.30, 1.31, 1.32). Debe existir en EKS."
  type        = string
  default     = "1.32"
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs a usar"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidrs" {
  description = "CIDR de subnets privadas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR de subnets públicas"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "node_group_instance_types" {
  description = "Tipos de instancia para el managed node group"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "node_group_desired_size" {
  type    = number
  default = 2
}

variable "node_group_min_size" {
  type    = number
  default = 1
}

variable "node_group_max_size" {
  type    = number
  default = 3
}
