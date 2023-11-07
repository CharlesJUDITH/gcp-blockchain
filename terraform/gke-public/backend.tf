terraform {
  backend "gcs" {
    bucket  = "cluster1-public"
    prefix  = "evmos/terraform/state/public"
  }
}
