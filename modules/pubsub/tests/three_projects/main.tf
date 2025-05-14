# tflint-ignore-file: terraform_standard_module_structure
data "google_project" "collector_auth" { provider = google.collector-auth }
data "google_project" "collector_topic" { provider = google.collector-topic }
data "google_project" "another_flow_src" { provider = google.another-flow-src }

resource "google_service_account" "collector" {
  provider = google.collector-auth

  project      = data.google_project.collector_auth.project_id
  account_id   = "ef-collector"
  display_name = "ef-collector"

  description = "Service account for the ElastiFlow Collector"
}

module "collector_topic" {
  source = "../../"

  providers = {
    google = google.collector-topic
  }

  project_id = data.google_project.collector_topic.project_id
  pubsub_topic_iam_members = {
    another_flow_src = { member = module.another_flow_src.writer_identity, role = "roles/pubsub.publisher" },
  }

  pubsub_topic_subscription_iam_members = {
    collector_subscriber = { member = google_service_account.collector.member, role = "roles/pubsub.subscriber" },
  }

  collector_service_account = {
    create = false
  }
}

module "another_flow_src" {
  source = "../../"

  providers = {
    google = google.another-flow-src
  }

  project_id = data.google_project.another_flow_src.project_id
  pubsub_topic = {
    create     = false
    project_id = data.google_project.collector_topic.project_id
  }
}
