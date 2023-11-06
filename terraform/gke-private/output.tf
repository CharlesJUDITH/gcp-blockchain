output "private_cluster_name" {
  description = "The name of the private GKE cluster"
  value       = module.gke_private.name
}

output "private_cluster_endpoint" {
  description = "The endpoint of the private GKE cluster"
  value       = module.gke_private.endpoint
  sensitive   = true
}

output "private_cluster_master_version" {
  description = "The current master version of the private GKE cluster"
  value       = module.gke_private.master_version
}
