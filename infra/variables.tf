variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Region for the resources"
  type        = string
}

variable "credentials_file" {
  description = "Path to the GCP credentials JSON file"
  type        = string
}

# Artifact Registry
variable "registry_name" {
  description = "Name of the Artifact Registry"
  type        = string
  default     = "my-docker-registry"
}

# MySQL Database
variable "mysql_root_password" {
  description = "Root password for the MySQL database"
  type        = string
}

variable "backend_db_name" {
  description = "Database name for the backend"
  type        = string
  default     = "backend_db"
}

variable "backend_user_name" {
  description = "Username for the backend database"
  type        = string
  default     = "backend_user"
}

variable "backend_user_password" {
  description = "Password for the backend database user"
  type        = string
}

variable "allowed_networks" {
  description = "Allowed IP ranges for Cloud SQL connections"
  type        = string
  default     = "0.0.0.0/0" # Replace with secure ranges
}

# Cloud Build Triggers
variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "backend_repo" {
  description = "Backend repository name"
  type        = string
}

variable "backend_branch" {
  description = "Branch to trigger builds for the backend"
  type        = string
  default     = "main"
}

variable "frontend_repo" {
  description = "Frontend repository name"
  type        = string
}

variable "frontend_branch" {
  description = "Branch to trigger builds for the frontend"
  type        = string
  default     = "main"
}

# VPC
variable "subnet_cidr" {
  description = "CIDR range for the VPC subnet"
  type        = string
  default     = "10.0.0.0/24"
}
