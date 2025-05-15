# tflint-ignore-file: terraform_standard_module_structure
data "google_project" "collector" { provider = google.collector }
data "google_project" "another_flow_src" { provider = google.another-flow-src }

module "collector" {
  source = "../../"

  providers = {
    google = google.collector
  }

  project_id = data.google_project.collector.project_id
  pubsub_topic_iam_members = {
    # Allow another-flow-src logging identity to publish to the topic
    another_flow_src = { member = "serviceAccount:service-984014891511@gcp-sa-logging.iam.gserviceaccount.com", role = "roles/pubsub.publisher" },
  }

  # dummy value, used for tests only
  pubsub_topic_subscription_iam_members = {
    test_subscriber = { member = "serviceAccount:tf-test@ef-test-a.iam.gserviceaccount.com", role = "roles/pubsub.subscriber" },
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
    project_id = data.google_project.collector.project_id
  }
}
