# Створюємо S3-бакет
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "lesson-5"
  }
}

# Налаштовуємо версіонування для S3-бакета
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Встановлюємо контроль власності для S3-бакета
resource "aws_s3_bucket_ownership_controls" "terraform_state_ownership" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Вмикаємо шифрування об'єктів у спокої (server-side encryption)
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Шифрування ключами, що керує S3 (SSE-S3)
    }
    bucket_key_enabled = true
  }
}

# Повністю блокуємо публічний доступ до бакета зі стейтами
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true # Блокуємо публічні ACL
  block_public_policy     = true # Блокуємо публічні bucket-політики
  ignore_public_acls      = true # Ігноруємо будь-які публічні ACL
  restrict_public_buckets = true # Обмежуємо доступ навіть якщо політика публічна
}

