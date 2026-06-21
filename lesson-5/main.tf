provider "aws" {
  region = "eu-north-1"
}

# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source = "./modules/s3-backend"                # Шлях до модуля
  bucket_name = "terraform-state-mkryvenko-21062026"  # Ім'я S3-бакета
}
