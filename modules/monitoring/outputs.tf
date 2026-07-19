output "monitoring_namespace" {
  description = "Namespace where Prometheus and Grafana are installed"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "grafana_service" {
  description = "Grafana service name (port-forward svc/grafana 3000:80)"
  value       = "grafana"
}

output "prometheus_server_service" {
  description = "Prometheus server service (datasource URL host)"
  value       = "prometheus-server.${var.namespace}.svc"
}

output "grafana_admin_user" {
  description = "Grafana admin username"
  value       = "admin"
}
