output "name" {
  value       = google_logging_project_sink.this.name
  description = "The name of the Google project-level logging sink"
}

output "destination" {
  value       = google_logging_project_sink.this.destination
  description = "The destination of the Google project-level logging sink"
}

output "writer_identity" {
  value       = google_logging_project_sink.this.writer_identity
  description = "The writer identity of the Google project-level logging sink"
}

output "pubsub_topic" {
  value = {
    id      = one(google_pubsub_topic.this[*].id)
    name    = one(google_pubsub_topic.this[*].name)
    project = one(google_pubsub_topic.this[*].project)
    subscription = {
      id      = one(google_pubsub_subscription.this[*].id)
      name    = one(google_pubsub_subscription.this[*].name)
      project = one(google_pubsub_subscription.this[*].project)
    }
  }
  description = "Attributes of the provisioned Pub/Sub topic and subscription"
}

output "service_account" {
  value = {
    id      = one(google_service_account.this[*].id)
    name    = one(google_service_account.this[*].name)
    project = one(google_service_account.this[*].project)
    email   = one(google_service_account.this[*].email)
    member  = one(google_service_account.this[*].member)
  }
  description = "Attributes of the provisioned service account, to be used in the ElastiFlow Collector"
}
