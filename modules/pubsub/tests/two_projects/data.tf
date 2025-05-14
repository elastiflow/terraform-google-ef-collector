# tflint-ignore-file: terraform_standard_module_structure
/*
  Following manifests are used for assertions only in the terratest.
*/

##############
# collector
##############
data "google_logging_sink" "collector" {
  provider = google.collector
  id       = "projects/${data.google_project.collector.project_id}/sinks/ef-collector"

  depends_on = [module.collector]
}

output "logging_sink_collector" {
  value       = data.google_logging_sink.collector
  description = "terratest output"
}

data "google_pubsub_topic" "collector" {
  provider = google.collector
  project  = data.google_project.collector.project_id
  name     = "ef-collector"

  depends_on = [module.collector]
}

output "pubsub_topic_collector" {
  value       = data.google_pubsub_topic.collector
  description = "terratest output"
}

data "google_pubsub_subscription" "collector" {
  provider = google.collector
  project  = data.google_project.collector.project_id
  name     = "ef-collector"

  depends_on = [module.collector]
}

output "pubsub_subscription_collector" {
  value       = data.google_pubsub_subscription.collector
  description = "terratest output"
}

data "google_pubsub_topic_iam_policy" "collector" {
  provider = google.collector
  topic    = "ef-collector"

  depends_on = [module.collector]
}

output "pubsub_topic_iam_policy_collector" {
  value = try(
    jsondecode(data.google_pubsub_topic_iam_policy.collector.policy_data),
    jsonencode({ "foo" : "bar" }),
  )
  description = "terratest output"
}

data "google_pubsub_subscription_iam_policy" "collector" {
  provider     = google.collector
  subscription = "projects/${data.google_project.collector.project_id}/subscriptions/ef-collector"

  depends_on = [module.collector]
}

output "pubsub_subscription_iam_policy_collector" {
  value = try(
    jsondecode(data.google_pubsub_subscription_iam_policy.collector.policy_data),
    jsonencode({ "foo" : "bar" }),
  )
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
