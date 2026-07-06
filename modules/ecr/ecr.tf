# Створюємо ECR-репозиторій для зберігання Docker-образів
resource "aws_ecr_repository" "this" {
  name                 = var.ecr_name             # Ім'я репозиторію
  image_tag_mutability = var.image_tag_mutability # MUTABLE або IMMUTABLE теги

  # Автоматичне сканування образів на вразливості при кожному push
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Шифрування образів у спокої (AES256 за замовчуванням)
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = var.ecr_name
    Environment = "lesson-5"
  }
}

# Політика доступу до репозиторію — дозволяє базові pull/push дії для акаунта
resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPushPull"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  })
}

# Lifecycle-політика — лишаємо останні 10 образів, старі видаляємо (економія коштів)
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Поточний AWS-акаунт — потрібен для ARN у політиці доступу
data "aws_caller_identity" "current" {}
