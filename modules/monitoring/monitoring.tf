resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus_chart_version
}

# metrics-server serves the metrics.k8s.io API (kubectl top + HPA CPU targets).
# Without it the django-app HPA reads "cpu: <unknown>" and never scales.
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = var.metrics_server_chart_version

  # EKS kubelet serving certs aren't signed by the cluster CA, so allow insecure TLS.
  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.grafana_chart_version

  values = [file("${path.module}/values-grafana.yaml")]

  set {
    name  = "adminPassword"
    value = var.grafana_admin_password
  }

  depends_on = [helm_release.prometheus]
}
