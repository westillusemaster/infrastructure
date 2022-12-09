# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = "swift-casing-370717"
  region  = "europe-west9"
}

# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "westillusemaster-tf-state"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "We still use master"
}

resource "google_container_cluster" "primary" {
  name     = "k8s-cluster"
  location = "europe-west9"

  disk_size = 50

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "k8s-node-pool"
  location   = "europe-west9"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
