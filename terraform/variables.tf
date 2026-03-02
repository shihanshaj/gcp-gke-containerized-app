variable "project_id" {
  description = "Your GCP project ID"
  default     = "cloud-portfolio-489014"
}

variable "region" {
  description = "GCP region"
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  default     = "us-central1-a"
}

variable "app_name" {
  description = "Name prefix for all resources"
  default     = "flask-app"
}

variable "cluster_name" {
  description = "GKE cluster name"
  default     = "flask-app-cluster"
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  default     = 2
}

variable "machine_type" {
  description = "GCP machine type for nodes"
  default     = "e2-medium"
}

variable "credentials_file" {
  description = "Path to GCP service account credentials JSON"
  default     = "/Users/shihanshaj/Desktop/gcp-credentials.json"
}
