variable "kubeconfig" {
  description = "Шлях до kubeconfig файлу"
  type        = string
}

variable "eks_cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}
