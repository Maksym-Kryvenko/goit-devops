output "repository_url" {
  description = "URL ECR-репозиторію для docker push/pull"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "ARN ECR-репозиторію"
  value       = aws_ecr_repository.this.arn
}

output "repository_name" {
  description = "Ім'я ECR-репозиторію"
  value       = aws_ecr_repository.this.name
}
