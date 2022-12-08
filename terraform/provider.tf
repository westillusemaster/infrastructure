
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