terraform {
  required_version = ">= 1.0" # Мінімальна версія Terraform

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Офіційний провайдер AWS
      version = "~> 6.0"        # Будь-яка версія 6.x
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.eks_cluster_name
}

provider "kubernetes" {
  host                   = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"               # Шлях до модуля
  bucket_name = "terraform-state-mkryvenko-21062026" # Ім'я S3-бакета
  table_name  = "terraform-locks"                    # Ім'я DynamoDB-таблиці для блокування
}

# Підключаємо модуль для VPC
module "vpc" {
  source             = "./modules/vpc"                               # Шлях до модуля VPC
  vpc_cidr_block     = "10.0.0.0/16"                                 # CIDR блок для VPC
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # Публічні підмережі
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # Приватні підмережі
  availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"] # Зони доступності
  vpc_name           = "vpc"                                         # Ім'я VPC
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-5-ecr"
  scan_on_push = true
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = "eks-cluster-demo" # Назва кластера
  # Кластеру віддаємо публічні + приватні підмережі: control-plane ENI живуть будь-де,
  # а внутрішній cloud-controller обирає ПУБЛІЧНІ підмережі для internet-facing LoadBalancer.
  subnet_ids = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  # Воркер-ноди — ЛИШЕ в приватних підмережах (вихід в інтернет через NAT Gateway).
  node_subnet_ids = module.vpc.private_subnets
  instance_type   = "t3.medium" # Тип інстансів (t3.medium = 17 podів/нода — вистачає на Jenkins+ArgoCD+моніторинг)
  desired_size    = 3           # Бажана кількість нодів
  max_size        = 4           # Максимальна кількість нодів
  min_size        = 1           # Мінімальна кількість нодів
}

module "jenkins" {
  source            = "./modules/jenkins"
  eks_cluster_name  = module.eks.eks_cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  github_user       = var.github_user
  github_pat        = var.github_pat

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

module "argo_cd" {
  source          = "./modules/argo_cd"
  namespace       = "argocd"
  chart_version   = "5.46.4"
  target_revision = "final-project"

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

module "monitoring" {
  source                 = "./modules/monitoring"
  namespace              = "monitoring"
  grafana_admin_password = "admin123"

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

module "rds" {
  source = "./modules/rds"

  name       = "myapp-db"
  use_aurora = true

  # --- Aurora-only ---
  engine_cluster                = "aurora-postgresql"
  engine_version_cluster        = "15.17"
  parameter_group_family_aurora = "aurora-postgresql15"


  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  db_name                 = "myapp"
  username                = "postgres"
  password                = "admin123AWS23"
  subnet_private_ids      = module.vpc.private_subnets
  subnet_public_ids       = module.vpc.public_subnets
  publicly_accessible     = true
  vpc_id                  = module.vpc.vpc_id
  multi_az                = true
  backup_retention_period = 7
  parameters = {
    max_connections = "200"
    log_statement   = "all"
    work_mem        = "4096"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}


