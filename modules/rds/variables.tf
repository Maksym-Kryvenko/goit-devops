variable "name" {
  description = "Base name for the DB instance/cluster and all derived resources (SG, subnet group, parameter group)"
  type        = string
}

variable "use_aurora" {
  description = "If true, create an Aurora cluster (+ writer/readers). If false, create a single standard aws_db_instance"
  type        = bool
  default     = false
}

# ---------- Standard RDS engine ----------
variable "engine" {
  description = "Engine for the standard RDS instance (e.g. postgres, mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version for the standard RDS instance"
  type        = string
  default     = "14.7"
}

variable "parameter_group_family_rds" {
  description = "Parameter group family matching the standard RDS engine/version (e.g. postgres15)"
  type        = string
  default     = "postgres15"
}

# ---------- Aurora cluster engine ----------
variable "engine_cluster" {
  description = "Engine for the Aurora cluster (e.g. aurora-postgresql, aurora-mysql)"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version_cluster" {
  description = "Engine version for the Aurora cluster"
  type        = string
  default     = "15.3"
}

variable "parameter_group_family_aurora" {
  description = "Cluster parameter group family matching the Aurora engine/version (e.g. aurora-postgresql15)"
  type        = string
  default     = "aurora-postgresql15"
}

variable "aurora_replica_count" {
  description = "Number of Aurora reader replicas to create (in addition to the writer)"
  type        = number
  default     = 1
}

# ---------- Common instance settings ----------
variable "instance_class" {
  description = "Instance class for the DB instance / Aurora cluster instances (e.g. db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB (standard RDS only; Aurora storage auto-scales)"
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for the standard RDS instance"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible. When true, uses public subnets; when false, private subnets"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

# ---------- Credentials ----------
variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
}

variable "username" {
  description = "Master username for the database"
  type        = string
}

variable "password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

# ---------- Networking ----------
variable "vpc_id" {
  description = "ID of the VPC where the security group is created"
  type        = string
}

variable "subnet_private_ids" {
  description = "List of private subnet IDs (used when publicly_accessible = false)"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "List of public subnet IDs (used when publicly_accessible = true)"
  type        = list(string)
}

variable "db_port" {
  description = "Port the database listens on (5432 for PostgreSQL, 3306 for MySQL)"
  type        = number
  default     = 5432
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the database on db_port"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# ---------- Parameter group ----------
variable "parameters" {
  description = "Map of DB parameters applied to the standard/Aurora parameter group"
  type        = map(string)
  default = {
    max_connections = "200"
    log_statement   = "all"
    work_mem        = "4096"
  }
}

variable "tags" {
  description = "Tags applied to all resources created by the module"
  type        = map(string)
  default     = {}
}
