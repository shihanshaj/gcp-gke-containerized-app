output "cluster_name" {
  value = google_container_cluster.main.name
}

output "cluster_location" {
  value = google_container_cluster.main.location
}

output "artifact_registry_url" {
  description = "Use this as your Docker image URL"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.app_name}"
}

output "kubectl_command" {
  description = "Run this to connect kubectl to your cluster"
  value       = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.zone} --project ${var.project_id}"
}