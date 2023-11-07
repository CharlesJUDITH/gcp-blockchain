output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "network_name" {
  description = "The name of the VPC network in the public cluster"
  value       = module.gcp-network.network_name
}
