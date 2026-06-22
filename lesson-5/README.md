# Lesson 5 — Terraform Infrastructure on AWS

Terraform-проєкт, що піднімає базову інфраструктуру в AWS: віддалене зберігання
стейтів (S3 + DynamoDB), мережу (VPC) та реєстр Docker-образів (ECR).

## Структура проєкту

```
lesson-5/
├── main.tf                 # Підключення всіх модулів + provider
├── backend.tf              # Backend конфіг для стейтів (S3 + DynamoDB lock)
├── outputs.tf              # Загальний вивід ресурсів усіх модулів
├── README.md               # Документація
│
└── modules/
    ├── s3-backend/         # S3-бакет + DynamoDB для стейтів
    │   ├── s3.tf           # Бакет, версіонування, ownership
    │   ├── dynamodb.tf     # Таблиця блокування стейтів
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── vpc/                # Мережева інфраструктура
    │   ├── vpc.tf          # VPC, 3 public + 3 private subnets, IGW
    │   ├── routes.tf       # Route tables, NAT Gateway, маршрути
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── ecr/                # Реєстр Docker-образів
        ├── ecr.tf          # Репозиторій, scan-on-push, політики
        ├── variables.tf
        └── outputs.tf
```

## Модулі

### `s3-backend`
Зберігає стейт-файли Terraform віддалено та безпечно.
- **S3-бакет** з увімкненим **версіонуванням** — історія всіх змін стейту.
- **DynamoDB-таблиця** (`terraform-locks`, hash key `LockID`) — блокує стейт під
  час `apply`, щоб двоє людей не змінювали інфраструктуру одночасно.
- **Outputs:** ім'я та ARN бакета, ім'я DynamoDB-таблиці.

### `vpc`
Мережева основа для решти ресурсів.
- **VPC** з CIDR `10.0.0.0/16`, увімкнені DNS support/hostnames.
- **3 публічні підмережі** — мають публічний IP, вихід в інтернет через **Internet Gateway**.
- **3 приватні підмережі** — без вхідного доступу, вихід в інтернет через **NAT Gateway** (з Elastic IP).
- **Route Tables** — окремі для public (→ IGW) і private (→ NAT).
- **Outputs:** ID VPC, списки ID public/private підмереж, ID IGW.

### `ecr`
Приватний реєстр Docker-образів.
- **ECR-репозиторій** з **scan-on-push** — автоскан образів на вразливості.
- **Шифрування** образів (AES256) у спокої.
- **Repository policy** — дозвіл push/pull для акаунта.
- **Lifecycle policy** — лишає останні 10 образів, старі видаляє (економія).
- **Outputs:** URL, ARN, ім'я репозиторію.

## Команди

```bash
terraform init       # Ініціалізація, завантаження провайдерів, підключення backend
terraform plan       # Перегляд змін перед застосуванням
terraform apply      # Створення/оновлення ресурсів в AWS
terraform destroy    # Видалення всіх ресурсів
```

## Важливо: bootstrap backend

`backend.tf` посилається на S3-бакет і DynamoDB-таблицю, які створює модуль
`s3-backend`. На першому запуску ці ресурси ще не існують, тому порядок такий:

1. Тимчасово закоментувати блок `backend "s3"` у `backend.tf`.
2. `terraform init && terraform apply` — створює бакет + таблицю (стейт локально).
3. Розкоментувати `backend "s3"`.
4. `terraform init` — Terraform запропонує перенести стейт у S3, відповісти `yes`.

> **Примітка про lock-таблицю.** Якщо `dynamodb_table` у backend вказує на ще
> не створену таблицю, перший `apply` запускається з `-lock=false` (саме він
> створює `terraform-locks`). Після цього блокування працює автоматично.

## Результат (terraform apply)

```text
Apply complete! Resources: 24 added, 0 changed, 0 destroyed.

Outputs:

dynamodb_table_name = "terraform-locks"
ecr_repository_url  = "495403531175.dkr.ecr.eu-north-1.amazonaws.com/lesson-5-ecr"
private_subnets = [
  "subnet-0b69dfb3d5776f034",
  "subnet-0b9701dad6f2e534c",
  "subnet-017907171803f9516",
]
public_subnets = [
  "subnet-04ff8bb5da7638d0c",
  "subnet-012b88ff83b1d142b",
  "subnet-0ca47b1959cf04022",
]
s3_bucket_name = "terraform-state-mkryvenko-21062026"
vpc_id         = "vpc-05ff1f393769e5d29"
```

Створено 24 ресурси: VPC з 3 публічними + 3 приватними підмережами, Internet
Gateway, NAT Gateway, маршрутні таблиці, DynamoDB-таблиця блокування та
ECR-репозиторій. Стейт зберігається в S3 з блокуванням через DynamoDB.
