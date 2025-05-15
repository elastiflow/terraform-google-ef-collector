locals {
  pubsub_topic_name = (var.pubsub_topic.name != null ? var.pubsub_topic.name : var.name)
  pubsub_topic_id = (var.pubsub_topic.create ?
    one(google_pubsub_topic.this[*].id)
    : "projects/${var.pubsub_topic.project_id}/topics/${local.pubsub_topic_name}"
  )

  collector_service_account_id = (var.collector_service_account.name != null ? var.collector_service_account.name : var.name)
}

resource "google_logging_project_sink" "this" {
  project                = var.project_id
  name                   = var.name
  destination            = "pubsub.googleapis.com/${local.pubsub_topic_id}"
  filter                 = var.filter
  unique_writer_identity = true

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value.name
      description = exclusions.value.description
      filter      = exclusions.value.filter
      disabled    = exclusions.value.disabled
    }
  }
}

##################
# Pub/Sub topic
##################
resource "google_pubsub_topic" "this" {
  count = (var.pubsub_topic.create ? 1 : 0)

  project                    = var.project_id
  name                       = local.pubsub_topic_name
  message_retention_duration = var.pubsub_topic.message_retention_duration

  dynamic "message_storage_policy" {
    for_each = (var.pubsub_topic.message_storage_policy != null ? [1] : [])
    content {
      allowed_persistence_regions = var.pubsub_topic.message_storage_policy.allowed_persistence_regions
      enforce_in_transit          = var.pubsub_topic.message_storage_policy.enforce_in_transit
    }
  }

  labels = var.labels
}

resource "google_pubsub_subscription" "this" {
  count = (var.pubsub_topic.create ? 1 : 0)

  project                      = var.project_id
  name                         = var.pubsub_topic.subscription.name
  topic                        = one(google_pubsub_topic.this[*].id)
  ack_deadline_seconds         = var.pubsub_topic.subscription.ack_deadline_seconds
  message_retention_duration   = var.pubsub_topic.subscription.message_retention_duration
  retain_acked_messages        = var.pubsub_topic.subscription.retain_acked_messages
  enable_exactly_once_delivery = true
  enable_message_ordering      = true

  dynamic "retry_policy" {
    for_each = (var.pubsub_topic.subscription.retry_policy != null ? [1] : [])
    content {
      minimum_backoff = var.pubsub_topic.subscription.retry_policy.minimum_backoff
      maximum_backoff = var.pubsub_topic.subscription.retry_policy.maximum_backoff
    }
  }

  labels = var.labels
}

resource "google_pubsub_topic_iam_member" "this" {
  for_each = (var.pubsub_topic.create ? var.pubsub_topic_iam_members : {})

  project = var.project_id
  topic   = one(google_pubsub_topic.this[*].id)
  member  = each.value.member
  role    = each.value.role
}

resource "google_pubsub_topic_iam_member" "this_logging_sink_publisher" {
  count = (var.pubsub_topic.create ? 1 : 0)

  project = var.project_id
  topic   = local.pubsub_topic_id
  member  = google_logging_project_sink.this.writer_identity
  role    = "roles/pubsub.publisher"
}

resource "google_pubsub_subscription_iam_member" "this" {
  for_each = (var.pubsub_topic.create ? var.pubsub_topic_subscription_iam_members : {})

  project      = var.project_id
  subscription = one(google_pubsub_subscription.this[*].id)
  member       = each.value.member
  role         = each.value.role
}

##############################
# Collector Service Account
##############################
resource "google_service_account" "this" {
  count = (var.collector_service_account.create && var.pubsub_topic.create ? 1 : 0)

  project    = var.project_id
  account_id = local.collector_service_account_id
  display_name = compact([
    var.collector_service_account.display_name,
    local.collector_service_account_id,
  ])[0]

  description = var.collector_service_account.description
}

resource "google_pubsub_subscription_iam_member" "this_ef_collector" {
  count = (var.collector_service_account.create && var.pubsub_topic.create ? 1 : 0)

  project      = var.project_id
  subscription = one(google_pubsub_subscription.this[*].id)
  member       = one(google_service_account.this[*].member)
  role         = "roles/pubsub.subscriber"
}
