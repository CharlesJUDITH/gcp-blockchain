variable "project_id" {
  description = "The GCP project id"
  type        = string
}

variable "region" {
  description = "The GCP region to create the bucket in"
  default     = "EU"
}

variable "bucket_name" {
  description  = "The name of the bucket to store Terraform state"
  type         = string
  default      = "cluster1"
}

variable "delete_after_days" {
  description = "Number of days after which to auto-delete objects"
  type        = number
  default     = 365
}

