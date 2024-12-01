# Configure the GCP provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a custom VPC network
resource "google_compute_network" "my_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Create a subnet within the VPC network
resource "google_compute_subnetwork" "my_subnet" {
  name          = var.subnet_name
  network       = google_compute_network.my_vpc.name
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
}

# Create an Artifact Registry repository
resource "google_artifact_registry_repository" "my_repo" {
  repository_id = var.artifact_registry_name  # Replace "artifact_registry_name" with a valid unique ID if needed
  format        = "DOCKER"
  location      = var.region
  project       = var.project_id
}

# Create a Cloud SQL instance for MySQL
resource "google_sql_database_instance" "my_sql_instance" {
  name             = var.sql_instance_name
  region           = var.region
  database_version = "MYSQL_8_0"

  settings {
    tier = "db-f1-micro"  # Choose the appropriate machine type
    ip_configuration {
      authorized_networks {
        name  = "my-allowed-network"
        value = "0.0.0.0/0"  # Adjust for better security
      }
    }
  }
}

# Create a database in the SQL instance
resource "google_sql_database" "my_database" {
  name     = var.database_name
  instance = google_sql_database_instance.my_sql_instance.name
}

# Create a user for the MySQL database
resource "google_sql_user" "my_db_user" {
  name     = var.mysql_user
  instance = google_sql_database_instance.my_sql_instance.name
  password = var.mysql_password
}

# Create a Secret Manager secret to store MySQL credentials
resource "google_secret_manager_secret" "mysql_credentials" {
  secret_id = "secret"

  labels = {
    label = "mysql_credentials"
  }

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-east1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "mysql_credentials_version" {
  secret      = google_secret_manager_secret.mysql_credentials.id
  secret_data = jsonencode({
    username = var.mysql_user,
    password = var.mysql_password
  })
}