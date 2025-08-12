############################################################
# ALB Controller – instalación por Helm con IRSA (recomendado)
############################################################

locals {
  alb_sa_namespace = "kube-system"
  alb_sa_name      = "aws-load-balancer-controller"
}

# Asegúrate que tu módulo EKS exponga el OIDC provider
# (En terraform-aws-modules/eks v20+, se crea si enable_irsa = true)
# Ejemplo en tu módulo (referencia):
# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.24"
#   enable_irsa = true
#   ...
# }

############################################################
# Rol IRSA para el AWS Load Balancer Controller
# Usa el módulo IAM para generar el rol + política adecuada
############################################################
module "iam_role_alb_controller" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.39"

  role_name = "${var.cluster_name}-alb-controller"

  # <-- aquí está el nombre correcto del flag
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}


############################################################
# ServiceAccount gestionado por Kubernetes provider
# (lo creamos nosotros para poder anotar el rol IRSA)
############################################################
resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = local.alb_sa_name
    namespace = local.alb_sa_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_role_alb_controller.iam_role_arn
    }
    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/component"  = "controller"
    }
  }

  automount_service_account_token = true

  # Asegura que exista el cluster antes de crear el SA
  depends_on = [module.eks]
}

############################################################
# Helm Release del AWS Load Balancer Controller
############################################################
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = local.alb_sa_namespace

  # Pinea una versión estable conocida; puedes actualizarla cuando necesites
  # Revisa el repo para la versión actual si quieres la más reciente
  # version   = "1.8.2"

  # Usamos el SA que creamos para IRSA (no dejar que el chart cree otro)
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = local.alb_sa_name
  }

  # Nombre del cluster
  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  # (Opcional, pero útil) especifica región y VPC si tu caso lo requiere
  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  # Si tu cluster usa endpoint privado, podrías necesitar:
  # set {
  #   name  = "image.repository"
  #   value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
  # }

  # Asegura orden correcto: primero EKS y el ServiceAccount con IRSA
  depends_on = [
    module.eks,
    kubernetes_service_account.alb_controller,
    module.iam_role_alb_controller
  ]
}
