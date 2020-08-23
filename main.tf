terraform {
  backend "remote" {
    organization = "laloloop"

    workspaces {
      name = "kubernetes_fundamentals"
    }
  }
}

// Provider

provider "google" {
  project     = var.project
  region      = "us-central1"
  version = "~> 3.35.0"
}

// Variables

variable "project" {
  description = "GCP project to create this resources into."
}

// Enable required APIs

resource "google_project_service" "cloud_resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "compute_engine_api" {
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

// VPC network

resource "google_compute_network" "vpc_lfclass" {
  name = "lfclass"
  description = "For my LF class"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_lfsclass" {
  name = "lfclass"
  ip_cidr_range = "10.2.0.0/16"
  network = google_compute_network.vpc_lfclass.id
}