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

variable "ssh-user" {
  description = "SSH user to log into the instances."
  default = "student"
}

variable "gce_ssh_pub_key_file" {
  description = "The public SSH key to log into the instances."
  default = "./id_rsa.pub"
}

// Enable required APIs

resource "google_project_service" "cloud_resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy = false
}

resource "google_project_service" "compute_engine_api" {
  service = "compute.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy = false
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

// Firewall rules

resource "google_compute_firewall" "fw_lfclass" {
  name    = "lfclass"
  description = "For my LF class"
  network = google_compute_network.vpc_lfclass.name

  allow {
    protocol = "all"
  }  

  source_ranges = ["0.0.0.0/0"]
}

// Nodes

resource "google_compute_instance" "master" {
  name = "master"
  zone = "us-central1-f"
  machine_type = "n1-standard-2"

  boot_disk {
    initialize_params {
      size = 20
      image = "ubuntu-1804-lts"
    }
  }

  metadata = {
    "ssh-keys" = "${var.ssh-user}:${file(var.gce_ssh_pub_key_file)}"
  }

  network_interface {
    network = google_compute_network.vpc_lfclass.name
    subnetwork = google_compute_subnetwork.subnet_lfsclass.name
    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "worker" {
  name = "worker"
  zone = "us-central1-f"
  machine_type = "n1-standard-2"

  boot_disk {
    initialize_params {
      size = 20
      image = "ubuntu-1804-lts"
    }
  }

  metadata = {
    "ssh-keys" = "${var.ssh-user}:${file(var.gce_ssh_pub_key_file)}"
  }

  network_interface {
    network = google_compute_network.vpc_lfclass.name
    subnetwork = google_compute_subnetwork.subnet_lfsclass.name
    access_config {
      // Ephemeral IP
    }
  }
}