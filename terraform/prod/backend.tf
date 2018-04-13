terraform {
  backend "gcs" {
    bucket = "smr-store-bucket"
    prefix = "terraform/prod"
  }
}
