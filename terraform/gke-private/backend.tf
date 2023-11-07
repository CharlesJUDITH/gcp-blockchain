terraform {
  backend "gcs" {
    bucket  = "cluster1-private" # Use the same bucket as your public cluster, but with a different prefix
    prefix  = "evmos/terraform/state/private-cluster"
  }
}