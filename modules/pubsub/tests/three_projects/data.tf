# tflint-ignore-file: terraform_standard_module_structure
/*
  Following manifests are used for assertions only in the terratest.
*/

##############
# collector
##############
data "google_logging_sink" "collector_topic" {
  provider = google.collector-topic
  id       = "projects/${data.google_project.collector_topic.project_id}/sinks/ef-collector"

  depends_on = [module.collector_topic]
}

output "logging_sink_collector_topic" {
  value       = data.google_logging_sink.collector_topic
  description = "terratest output"
}

data "google_pubsub_topic" "collector_topic" {
  provider = google.collector-topic
  project  = data.google_project.collector_topic.project_id
  name     = "ef-collector"

  depends_on = [module.collector_topic]
}

output "pubsub_topic_collector_topic" {
  value       = data.google_pubsub_topic.collector_topic
  description = "terratest output"
}

data "google_pubsub_subscription" "collector_topic" {
  provider = google.collector-topic
  project  = data.google_project.collector_topic.project_id
  name     = "ef-collector"

  depends_on = [module.collector_topic]
}

output "pubsub_subscription_collector_topic" {
  value       = data.google_pubsub_subscription.collector_topic
  description = "terratest output"
}

data "google_pubsub_topic_iam_policy" "collector_topic" {
  provider = google.collector-topic
  topic    = "ef-collector"

  depends_on = [module.collector_topic]
}

output "pubsub_topic_iam_policy_collector_topic" {
  value = try(
    jsondecode(data.google_pubsub_topic_iam_policy.collector_topic.policy_data),
    jsonencode({ "foo" : "bar" }),
  )
  description = "terratest output"
}

data "google_pubsub_subscription_iam_policy" "collector_topic" {
  provider     = google.collector-topic
  subscription = "projects/${data.google_project.collector_topic.project_id}/subscriptions/ef-collector"

  depends_on = [module.collector_topic]
}

output "pubsub_subscription_iam_policy_collector_topic" {
  value = try(
    jsondecode(data.google_pubsub_subscription_iam_policy.collector_topic.policy_data),
    jsonencode({ "foo" : "bar" }),
  )
  description = "terratest output"
}

data "google_service_accounts" "collector_topic" {
  provider = google.collector-topic

  depends_on = [module.collector_topic]
}

output "google_service_accounts_collector_topic" {
  value       = data.google_service_accounts.collector_topic
  description = "terratest output"
}

#####################
# another-flow-src
#####################
data "google_logging_sink" "another_flow_src" {
  provider = google.another-flow-src
  id       = "projects/${data.google_project.another_flow_src.project_id}/sinks/ef-collector"

  depends_on = [module.another_flow_src]
}

output "logging_sink_another_flow_src" {
  value       = data.google_logging_sink.another_flow_src
  description = "terratest output"
}
