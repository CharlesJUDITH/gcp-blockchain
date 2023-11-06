variable "project_id" {
  default     = "evmos-403721"
  description = "The project ID to host the cluster in"
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = "europe-west1"
}

variable "env_name" {
  description = "The environment for the GKE cluster"
  type        = string
  default     = "prod"
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  type        = string
  default     = "cluster-2"
}

variable "network" {
  description = "The VPC network created to host the cluster in"
  type        = string
  default     = "gke-network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  type        = string
  default     = "gke-subnet"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  type        = string
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  type        = string
  default     = "ip-range-services"
}

variable "master_ipv4_cidr_block" {
  description = "The master IPv4 CIDR block for the GKE cluster"
  type        = string
  default     = "172.16.0.0/28"
}

variable "master_authorized_networks" {
  description = "The master authorized networks for the GKE cluster"
  type        = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    {
      cidr_block   = "192.168.1.0/24"
      display_name = "My Office"
    }
  ]
}

variable "node_machine_type" {
  description = "The machine type for the GKE cluster nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_min_count" {
  description = "Minimum number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "node_max_count" {
  description = "Maximum number of nodes in the node pool"
  type        = number
  default     = 2
}

variable "disk_size_gb" {
  description = "The size of the disks attached to the nodes"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "The type of the disk attached to the nodes"
  type        = string
  default     = "pd-standard"
}

variable "regional" {
  description = "Whether to create a regional cluster"
  type        = bool
  default     = true
}
