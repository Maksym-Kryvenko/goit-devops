# Lesson 7 — Kubernetes (EKS) + ECR + Helm

Terraform піднімає EKS-кластер у наявній VPC, ECR-репозиторій для Docker-образу
Django, а Helm-чарт деплоїть застосунок із Service `LoadBalancer`, HPA (2→6) та
ConfigMap зі змінними середовища.

## Структура

```
lesson-7/
├── main.tf                 # Підключення модулів + provider
├── backend.tf              # S3 + DynamoDB backend для стейту
├── outputs.tf              # Загальні outputs
│
├── modules/
│   ├── s3-backend/         # S3-бакет + DynamoDB для стейту
│   ├── vpc/                # VPC, 3 public + 3 private subnets, IGW, NAT
│   ├── ecr/                # ECR-репозиторій (scan-on-push, lifecycle)
│   └── eks/                # EKS-кластер + Node Group + IAM-ролі
│
└── charts/django-app/      # Helm-чарт
    ├── Chart.yaml
    ├── values.yaml         # image, service, config(env), autoscaling
    └── templates/
        ├── deployment.yaml # Django image з ECR + envFrom ConfigMap
        ├── service.yaml    # type: LoadBalancer
        ├── configmap.yaml  # env-змінні (з topic 4)
        └── hpa.yaml        # CPU > 70%, 2→6 podів
```

## 1. Terraform — інфраструктура

```bash
terraform init
terraform plan
terraform apply
```

Створює VPC, ECR, EKS-кластер та Node Group. Outputs: endpoint кластера,
ім'я кластера, URL ECR.

## 2. Доступ через kubectl

```bash
aws eks update-kubeconfig --region eu-north-1 --name eks-cluster-demo
kubectl get nodes
```

## 3. Білд та пуш образу в ECR

```bash
ACCOUNT=495403531175
REGION=eu-north-1
REPO=lesson-5-ecr
ECR=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com

# Логін у ECR
aws ecr get-login-password --region $REGION \
  | docker login --username AWS --password-stdin $ECR

# Білд із Dockerfile з topic 4 (django/) і пуш
docker build -t $REPO ../django
docker tag $REPO:latest $ECR/$REPO:latest
docker push $ECR/$REPO:latest
```

> Для Apple Silicon білд під amd64 (ноди EKS x86):
> `docker build --platform linux/amd64 -t $REPO ../django`

## 4. Деплой через Helm

```bash
helm install django-app ./charts/django-app
# або оновлення:
helm upgrade --install django-app ./charts/django-app

kubectl get pods
kubectl get svc django-app-django   # EXTERNAL-IP = адреса LoadBalancer
kubectl get hpa
```

`values.yaml` містить:
- **image** — URL ECR + tag,
- **service** — `LoadBalancer`, port 80 → 8000,
- **config** — env-змінні (POSTGRES_*) → ConfigMap → `envFrom`,
- **autoscaling** — `minReplicas: 2`, `maxReplicas: 6`, CPU 70%.

## Примітки

- HPA рахує % CPU від `resources.requests.cpu`, тому в чарті заданий requests.
  Для роботи HPA в кластері має бути встановлений **metrics-server**.
- Node Group за замовчуванням малий (`t2.micro`, 1 нода). Для 2–6 podів Django
  + системних podів збільш `instance_type`/`desired_size` у `main.tf`.
