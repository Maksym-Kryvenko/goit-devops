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
