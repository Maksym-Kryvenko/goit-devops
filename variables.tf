variable "github_user" {
  description = "GitHub username for the Jenkins CI git-push credential"
  type        = string
  default     = "Maksym-Kryvenko"
}

variable "github_pat" {
  description = "GitHub Personal Access Token (repo scope) seeded as the 'github-token' Jenkins credential. Supply via TF_VAR_github_pat, never commit."
  type        = string
  sensitive   = true
}

# --- Secrets ---
variable "db_password" {
  description = "RDS/Aurora master password. Supply via TF_VAR_db_password or terraform.tfvars, never commit."
  type        = string
  sensitive   = true
}

variable "grafana_admin_password" {
  description = "Grafana admin password. Supply via TF_VAR_grafana_admin_password or terraform.tfvars, never commit."
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password. Supply via TF_VAR_jenkins_admin_password or terraform.tfvars, never commit."
  type        = string
  sensitive   = true
}

variable "django_secret_key" {
  description = "Django SECRET_KEY. Seeded into the django-app-secret k8s Secret. Supply via terraform.tfvars, never commit."
  type        = string
  sensitive   = true
}
