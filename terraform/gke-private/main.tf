terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.47.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version = "24.1.0"
  depends_on   = [module.gke_private]
  project_id   = var.project_id
  location     = module.gke_private.location
  cluster_name = module.gke_private.name
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
}

// Private GKE cluster configuration
module "gke_private" {
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                 = "24.1.0"
  project_id              = var.project_id
  name                    = "${var.cluster_name}-${var.env_name}-private"
  regional                = true
  region                  = var.region
  network                = module.gcp-network-private.network_name
  subnetwork             = module.gcp-network-private.subnets_names[0]
  ip_range_pods          = "${var.ip_range_pods_name}-private"
  ip_range_services      = "${var.ip_range_services_name}-private"
  enable_private_nodes    = true
  enable_private_endpoint = true
  master_ipv4_cidr_block  = "172.16.0.0/28"

  node_pools = [
    {
      name                      = "node-pool"
      machine_type              = "e2-medium"
      node_locations            = "europe-west1-b,europe-west1-c,europe-west1-d"
      min_count                 = 1
      max_count                 = 2
      disk_size_gb              = 30
    },
  ]

  master_authorized_networks = [
    {
      #cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
      cidr_block   = "192.168.1.0/24"
      display_name = "My network"
    },
  ]

}

// VPC Network for the private cluster
module "gcp-network-private" {
  source       = "terraform-google-modules/network/google"
  version      = "6.0.0"
  project_id   = var.project_id
  network_name = "${var.network}-${var.env_name}-private"
  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}-private"
      subnet_ip     = "10.11.0.0/16"
      subnet_region = var.region
    },
  ]
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}-private" = [
      {
        range_name    = "${var.ip_range_pods_name}-private"
        ip_cidr_range = "10.21.0.0/16"
      },
      {
        range_name    = "${var.ip_range_services_name}-private"
        ip_cidr_range = "10.31.0.0/16"
      },
    ]
  }
}

// VPC Peering between public and private clusters
data "terraform_remote_state" "public_cluster" {
  backend = "gcs"
  config = {
    bucket = "cluster1-public"
    prefix = "evmos/terraform/state/public" # Make sure this points to the state file of your public cluster
  }
}

# Use the output from the public cluster state to set up a resource in the private cluster
# resource "google_compute_network_peering" "peering" {
#   name         = "peering-name"
#   #network      = module.gcp-network-private.network_name
#   #peer_network = data.terraform_remote_state.public_cluster.outputs.network_name
#   network      = "${var.project_id}/global/networks/${module.gcp-network-private.network_name}"
#   peer_network = "${data.terraform_remote_state.public_cluster.outputs.project_id}/global/networks/${data.terraform_remote_state.public_cluster.outputs.network_name}"
# }

