terraform {
  backend "s3" {
    bucket         = "terraform-state-mkryvenko-21062026"# Назва S3-бакета
    key            = "lesson-5/terraform.tfstate"   # Шлях до файлу стейту
    region         = "eu-north-1"                    # Регіон AWS
    use_lockfile   = true                           # S3-native locking (Terraform 1.10+)
    encrypt        = true                           # Шифрування файлу стейту
  }
}