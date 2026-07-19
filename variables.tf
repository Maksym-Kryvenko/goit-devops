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
