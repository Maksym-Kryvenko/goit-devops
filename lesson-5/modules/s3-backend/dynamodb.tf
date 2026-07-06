# Створюємо DynamoDB-таблицю для блокування стейтів Terraform
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name    # Ім'я таблиці (наприклад, terraform-locks)
  billing_mode = "PAY_PER_REQUEST" # Оплата за запит — не треба резервувати потужність
  hash_key     = "LockID"          # Обов'язковий ключ, який Terraform використовує для блокування

  attribute {
    name = "LockID" # Атрибут-ключ, тип рядок
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "lesson-5"
  }
}
