provider "google" {
  alias                       = "collector"
  project                     = var.ef_test_a.project_id
  region                      = "us-east1"
  impersonate_service_account = var.ef_test_a.impersonate_service_account

  default_labels = {
    project = "ef-test"
    plane   = "none"
    cloud   = "gcp"
    env     = "ops"
    region  = "us-east1"
  }
}

provider "google" {
  alias                       = "another-flow-src"
  project                     = var.ef_test_b.project_id
  region                      = "us-east1"
  impersonate_service_account = var.ef_test_b.impersonate_service_account

  default_labels = {
    project = "ef-test"
    plane   = "none"
    cloud   = "gcp"
    env     = "ops"
    region  = "us-east1"
  }
}
