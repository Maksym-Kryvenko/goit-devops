terraform {
  backend "s3" {
    bucket         = "terraform-state-mkryvenko-21062026" # Назва S3-бакета
    key            = "final-project/terraform.tfstate"    # Шлях до файлу стейту
    region         = "eu-north-1"                         # Регіон AWS
    dynamodb_table = "terraform-locks"                    # DynamoDB-таблиця для блокування стейту
    encrypt        = true                                 # Шифрування файлу стейту
  }
}