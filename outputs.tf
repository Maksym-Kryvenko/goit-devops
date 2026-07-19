#-------------Backend-----------------

output "s3_bucket_name" {
  description = "Назва S3-бакета для стейтів"
  value       = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "Ім'я DynamoDB-таблиці для блокування стейтів"
  value       = module.s3_backend.dynamodb_table_name
}

#-------------VPC-----------------

output "vpc_id" {
  description = "ID створеної VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Список ID публічних підмереж"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Список ID приватних підмереж"
  value       = module.vpc.private_subnets
}

output "ecr_repository_url" {
  description = "URL ECR-репозиторію"
  value       = module.ecr.repository_url
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

#-------------EKS-----------------

output "eks_cluster_endpoint" {
  description = "EKS API endpoint for connecting to the cluster"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.eks_cluster_name
}

output "eks_node_role_arn" {
  description = "IAM role ARN for EKS Worker Nodes"
  value       = module.eks.eks_node_role_arn
}

#-------------Jenkins-----------------

output "jenkins_release_name" {
  description = "Name of the Jenkins release"
  value       = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  description = "Namespace of the Jenkins release"
  value       = module.jenkins.jenkins_namespace
}

#-------------RDS-----------------

output "rds_endpoint" {
  description = "Writer endpoint of the RDS instance / Aurora cluster"
  value       = module.rds.endpoint
}

output "rds_port" {
  description = "Port the database listens on"
  value       = module.rds.port
}

output "rds_security_group_id" {
  description = "Security group ID attached to the database"
  value       = module.rds.security_group_id
}

#-------------Monitoring-----------------

output "monitoring_namespace" {
  description = "Namespace of the monitoring stack"
  value       = module.monitoring.monitoring_namespace
}

output "grafana_service" {
  description = "Grafana service (kubectl port-forward -n monitoring svc/grafana 3000:80, admin/admin123)"
  value       = module.monitoring.grafana_service
}