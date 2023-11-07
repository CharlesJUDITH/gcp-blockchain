provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "public_terraform_state" {
  name          = "${var.bucket_name}-public"
  location      = var.region
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = var.delete_after_days
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket" "private_terraform_state" {
  name          = "${var.bucket_name}-private"
  location      = var.region
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = var.delete_after_days
    }
    action {
      type = "Delete"
    }
  }
}

