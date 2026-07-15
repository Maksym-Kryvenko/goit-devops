variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
}

variable "table_name" {
  description = "Ім'я DynamoDB-таблиці для блокування стейтів"
  type        = string
  default     = "terraform-locks"
}

