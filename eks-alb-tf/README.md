# EKS Cluster con Terraform y AWS Load Balancer Controller

Este proyecto implementa **Infrastructure as Code (IaC)** con **Terraform** para desplegar un clúster de **Amazon EKS** optimizado para bajo costo (incluyendo opciones Free Tier) y con el **AWS Load Balancer Controller** instalado vía Helm, listo para manejar ALB/NLB de forma automática.

---

## 🚀 Arquitectura

- **EKS Cluster**: Kubernetes `1.32` con 2 nodos administrados o spot
- **VPC**: VPC personalizada con subredes públicas y privadas en 2 AZs
- **Node Group**: Instancias `t3.micro` (Free Tier elegible)
- **Networking**: 1 NAT Gateway (reduce costos frente a múltiples NATs)
- **Seguridad**: Security Groups y roles IAM siguiendo buenas prácticas
- **AWS Load Balancer Controller**:
  - Instalado mediante Helm
  - Configurado con **IRSA** para permisos seguros
  - Listo para crear y administrar ALB/NLB

---

## 💰 Optimización de Costos

- Instancias `t3.micro` (Free Tier)
- Un solo NAT Gateway
- Configuración mínima de nodos
- Opción para usar instancias Spot (comentada en `main.tf`)

---

## 📋 Requisitos Previos

1. **AWS CLI** configurado con credenciales y permisos para EKS
2. **Terraform** >= `1.0`
3. **kubectl** para gestionar el clúster
4. Cuenta AWS con permisos para:
   - EKS
   - VPC
   - IAM
   - ELB/NLB

---

## ⚡ Despliegue Rápido

### 1️⃣ Inicializar Terraform
```bash
cd aws/eks-alb-tf
terraform init
