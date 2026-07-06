variable "name" {
  description = "Назва Helm-релізу"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Версія Argo CD чарта"
  type        = string
  default     = "5.46.4"
}

variable "repo_url" {
  description = "Git repository URL for the app-of-apps application and repository secret"
  type        = string
  default     = "https://github.com/Maksym-Kryvenko/goit-devops.git"
}

variable "target_revision" {
  description = "Git branch/tag/revision to track"
  type        = string
  default     = "main"
}

variable "chart_path" {
  description = "Path within the repository to the Helm chart"
  type        = string
  default     = "charts/django-app"
}

variable "dest_namespace" {
  description = "Destination namespace for the deployed application"
  type        = string
  default     = "default"
}

variable "git_username" {
  description = "Username for the Git repository (empty for public repos)"
  type        = string
  default     = ""
}

variable "git_password" {
  description = "Password/token for the Git repository (empty for public repos)"
  type        = string
  default     = ""
  sensitive   = true
}
