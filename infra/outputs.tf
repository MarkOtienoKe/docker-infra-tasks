# Output the VPC network name
output "vpc_name" {
  value = google_compute_network.my_vpc.name
}

# Output the subnet name
output "subnet_name" {
  value = google_compute_subnetwork.my_subnet.name
}

# Output the Artifact Registry repository name
output "artifact_registry_name" {
  value = google_artifact_registry_repository.my_repo.name
}

# Output the SQL instance name
output "sql_instance_name" {
  value = google_sql_database_instance.my_sql_instance.name
}

# Output the database name
output "database_name" {
  value = google_sql_database.my_database.name
}

# Output the secret name
output "mysql_secret_name" {
  value = google_secret_manager_secret.mysql_credentials.secret_id
}
