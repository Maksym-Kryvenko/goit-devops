output "vpc_id" {
  description = "ID створеної VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR блок VPC (для allowed_cidr_blocks у RDS SG)"
  value       = aws_vpc.main.cidr_block
}

output "public_subnets" {
  description = "Список ID публічних підмереж"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "Список ID приватних підмереж"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

