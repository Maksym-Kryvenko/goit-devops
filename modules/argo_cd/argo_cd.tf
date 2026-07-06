resource "helm_release" "argo_cd" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  create_namespace = true
}

resource "helm_release" "argo_apps" {
  name             = "${var.name}-apps"
  chart            = "${path.module}/charts"
  namespace        = var.namespace
  create_namespace = false

  values = [
    file("${path.module}/charts/values.yaml")
  ]

  set {
    name  = "applications[0].source.repoURL"
    value = var.repo_url
  }
  set {
    name  = "applications[0].source.path"
    value = var.chart_path
  }
  set {
    name  = "applications[0].source.targetRevision"
    value = var.target_revision
  }
  set {
    name  = "applications[0].destination.namespace"
    value = var.dest_namespace
  }
  set {
    name  = "repositories[0].url"
    value = var.repo_url
  }
  set {
    name  = "repositories[0].username"
    value = var.git_username
  }
  set_sensitive {
    name  = "repositories[0].password"
    value = var.git_password
  }

  depends_on = [helm_release.argo_cd]
}

