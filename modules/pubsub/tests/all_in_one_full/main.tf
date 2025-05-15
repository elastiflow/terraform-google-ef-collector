# tflint-ignore-file: terraform_standard_module_structure
module "this" {
  source = "../../"

  project_id                            = "ef-test-a"
  name                                  = var.name
  labels                                = var.labels
  filter                                = var.filter
  exclusions                            = var.exclusions
  pubsub_topic                          = var.pubsub_topic
  pubsub_topic_iam_members              = var.pubsub_topic_iam_members
  pubsub_topic_subscription_iam_members = var.pubsub_topic_subscription_iam_members
  collector_service_account             = var.collector_service_account
}

output "name" {
  value       = module.this.name
  description = "terratest output"
}

output "destination" {
  value       = module.this.destination
  description = "terratest output"
}

output "writer_identity" {
  value       = module.this.writer_identity
  description = "terratest output"
}

output "pubsub_topic" {
  value       = module.this.pubsub_topic
  description = "terratest output"
}

output "service_account" {
  value       = module.this.service_account
  description = "terratest output"
}
