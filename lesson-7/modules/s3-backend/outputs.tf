output "s3_bucket_name" {
  description = "Назва S3-бакета для стейтів"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "s3_bucket_arn" {
  description = "ARN S3-бакета для стейтів"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "Ім'я DynamoDB-таблиці для блокування"
  value       = aws_dynamodb_table.terraform_locks.name
}
