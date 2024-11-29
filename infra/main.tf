provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

# 1. Google Artifact Registry
resource "google_artifact_registry_repository" "docker_registry" {
  name         = "my-docker-registry"
  format       = "DOCKER"
  location     = var.region
}

# 2. Google Cloud MySQL Database
resource "google_sql_database_instance" "mysql_instance" {
  name             = "my-mysql-instance"
  region           = var.region
  database_version = "MYSQL_8_0"

  settings {
    tier = "db-n1-standard-1"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "default-network"
        value = var.allowed_networks
      }
    }
  }

  root_password = var.mysql_root_password
}

resource "google_sql_database" "backend_db" {
  name     = var.backend_db_name
  instance = google_sql_database_instance.mysql_instance.name
}

resource "google_sql_user" "backend_user" {
  name     = var.backend_user_name
  instance = google_sql_database_instance.mysql_instance.name
  password = var.backend_user_password
}

# 3. Build Triggers
resource "google_cloudbuild_trigger" "backend_trigger" {
  name        = "backend-build-trigger"
  description = "Trigger for backend"
  github {
    owner = var.github_owner
    name  = var.backend_repo
    push {
      branch = var.backend_branch
    }
  }
  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "us-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_registry.name}/backend:latest", "."]
    }
    images = ["us-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_registry.name}/backend:latest"]
  }
}

resource "google_cloudbuild_trigger" "frontend_trigger" {
  name        = "frontend-build-trigger"
  description = "Trigger for frontend"
  github {
    owner = var.github_owner
    name  = var.frontend_repo
    push {
      branch = var.frontend_branch
    }
  }
  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "us-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_registry.name}/frontend:latest", "."]
    }
    images = ["us-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_registry.name}/frontend:latest"]
  }
}

#4 GCS
resource "google_storage_bucket" "terraform_state" {
  name          = "terraform-state-${random_id.bucket_suffix.hex}"
  location      = var.region
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}


# 5. VPC
resource "google_compute_network" "custom_vpc" {
  name                    = "custom-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "custom-subnet"
  region        = var.region
  network       = google_compute_network.custom_vpc.id
  ip_cidr_range = var.subnet_cidr
}
