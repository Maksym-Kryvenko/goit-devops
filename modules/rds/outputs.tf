# Primary write endpoint (Aurora cluster endpoint or standard instance endpoint)
output "endpoint" {
  description = "Connection endpoint (writer) for the database"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.standard[0].endpoint
}

# Aurora reader endpoint; null for standard RDS
output "reader_endpoint" {
  description = "Aurora reader (read-only) endpoint; null when use_aurora = false"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "port" {
  description = "Port the database listens on"
  value       = var.db_port
}

output "db_name" {
  description = "Name of the initial database"
  value       = var.db_name
}

output "username" {
  description = "Master username"
  value       = var.username
}

output "identifier" {
  description = "Identifier of the created RDS instance or Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].cluster_identifier : aws_db_instance.standard[0].identifier
}

output "security_group_id" {
  description = "ID of the security group attached to the database"
  value       = aws_security_group.rds.id
}

output "subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.default.name
}

output "parameter_group_name" {
  description = "Name of the (cluster) parameter group in use"
  value       = var.use_aurora ? aws_rds_cluster_parameter_group.aurora[0].name : aws_db_parameter_group.standard[0].name
}
