variable "namespace" {
  description = "Namespace for monitoring stack (Prometheus + Grafana)"
  type        = string
  default     = "monitoring"
}

variable "prometheus_chart_version" {
  description = "Helm chart version for prometheus-community/prometheus"
  type        = string
  default     = "25.27.0"
}

variable "grafana_chart_version" {
  description = "Helm chart version for grafana/grafana"
  type        = string
  default     = "8.5.1"
}

variable "metrics_server_chart_version" {
  description = "Helm chart version for metrics-server (serves metrics.k8s.io for HPA)"
  type        = string
  default     = "3.12.1"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}
