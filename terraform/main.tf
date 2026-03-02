# ============================================================
# PROVIDER
# ============================================================

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

# ============================================================
# ARTIFACT REGISTRY — Stores your Docker images
# Like DockerHub but private on GCP
# ============================================================

resource "google_artifact_registry_repository" "main" {
  location      = var.region
  repository_id = var.app_name
  description   = "Docker repository for flask app"
  format        = "DOCKER"
}

# ============================================================
# VPC NETWORK — Private network for our cluster
# ============================================================

resource "google_compute_network" "main" {
  name                    = "${var.app_name}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "${var.app_name}-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.main.id

  # Secondary ranges for pods and services
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/20"
  }
}

# ============================================================
# GKE CLUSTER — Your Kubernetes cluster
# ============================================================

resource "google_container_cluster" "main" {
  name     = var.cluster_name
  location = var.zone

  deletion_protection      = false
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.main.name
  subnetwork = google_compute_subnetwork.main.name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  # Enable Workload Identity (secure way for pods to access GCP services)
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# ============================================================
# NODE POOL — The actual machines in your cluster
# ============================================================

resource "google_container_node_pool" "main" {
  name     = "${var.cluster_name}-node-pool"
  location = var.zone
  cluster  = google_container_cluster.main.name

  node_count = var.node_count

  # Auto-scaling: can grow from 2 to 4 nodes
  autoscaling {
    min_node_count = 2
    max_node_count = 4
  }

  # Auto-repair and upgrade for production reliability
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.machine_type
    disk_size_gb = 30

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = "production"
      app = var.app_name
    }
  }
}