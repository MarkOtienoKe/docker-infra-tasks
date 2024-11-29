output "artifact_registry_url" {
  description = "URL of the Artifact Registry"
  value       = "us-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_registry.name}"
}

output "mysql_instance_connection_name" {
  description = "Connection name for the MySQL instance"
  value       = google_sql_database_instance.mysql_instance.connection_name
}

output "backend_build_trigger_id" {
  description = "ID of the backend build trigger"
  value       = google_cloudbuild_trigger.backend_trigger.id
}

output "frontend_build_trigger_id" {
  description = "ID of the frontend build trigger"
  value       = google_cloudbuild_trigger.frontend_trigger.id
}

output "frontend_bucket_name" {
  description = "Name of the storage bucket for frontend assets"
  value       = google_storage_bucket.frontend_assets.name
}

output "vpc_name" {
  description = "Name of the created VPC"
  value       = google_compute_network.custom_vpc.name
}

output "subnet_name" {
  description = "Name of the created subnet"
  value       = google_compute_subnetwork.subnet.name
}
