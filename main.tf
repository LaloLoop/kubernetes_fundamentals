terraform {
  backend "remote" {
    organization = "laloloop"

    workspaces {
      name = "kubernetes_fundamentals_lfs258"
    }
  }
}

// VPC network

resource "google_compute_network" "vpc_lfclass" {
  name = "lfclass"
  description = "For my LF class"
}

resource "google_compute_subnetwork" "subnet_lfsclass" {
  name = "lfclass"
  region = "us-central1"
  ip_cidr_range = "10.2.0.0/16"
  network = google_compute_network.vpc_lfclass
}