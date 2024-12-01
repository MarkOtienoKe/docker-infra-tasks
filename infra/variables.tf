# Project ID
variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

# Region
variable "region" {
  description = "The region for GCP resources"
  type        = string
  default     = "africa-south1"
}

# VPC Name
variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "maks-vpc"
}

# Subnet Name
variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "maks-subnet"
}

# Artifact Registry Name
variable "artifact_registry_name" {
  description = "The name of the Artifact Registry repository"
  type        = string
  default     = "maks-repo"
}

# SQL Instance Name
variable "sql_instance_name" {
  description = "The name of the SQL instance"
  type        = string
  default     = "my-sql-instance"
}

# Database Name
variable "database_name" {
  description = "The name of the database"
  type        = string
  default     = "messages_db"
}

# MySQL User Name
variable "mysql_user" {
  description = "The username for the MySQL database"
  type        = string
  default     = "msguser"
}

# MySQL Password
variable "mysql_password" {
  description = "The password for the MySQL database user"
  type        = string
  sensitive   = true
}
