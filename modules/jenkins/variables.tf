variable "eks_cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the EKS OIDC provider"
  type        = string
}

variable "github_user" {
  description = "GitHub username for the CI git-push credential"
  type        = string
  default     = "Maksym-Kryvenko"
}

variable "github_pat" {
  description = "GitHub Personal Access Token (repo scope) seeded as the 'github-token' Jenkins credential"
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password (no default — supplied from root var)"
  type        = string
  sensitive   = true
}

variable "ecr_repo_url" {
  description = "ECR repository URL (module.ecr.repository_url) exposed to the CI pipeline as the ECR_REPO env var"
  type        = string
}
