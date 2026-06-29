variable "ecr_name" {
  description = "Ім'я ECR-репозиторію"
  type        = string
}

variable "scan_on_push" {
  description = "Чи сканувати образи на вразливості при push"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "Мутабельність тегів образів (MUTABLE або IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}
