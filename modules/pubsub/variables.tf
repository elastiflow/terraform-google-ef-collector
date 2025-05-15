variable "project_id" {
  type        = string
  description = "The ID of the project where flow"
}

variable "name" {
  type        = string
  default     = "ef-collector"
  description = <<-EOT
    The name of the Google project-level logging sink.
    If individual names are not provided, all other resources use this as a name.
  EOT
}

variable "labels" {
  type = map(string)
  default = {
    app = "ef-collector"
  }
  description = "The labels to all applicable resources."
}

variable "filter" {
  type        = string
  default     = "resource.type = \"gce_subnetwork\""
  description = <<-EOT
    The filter to apply when exporting logs. Only log entries that match the filter are exported.
    See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/advanced_filters) for information on how to write a filter.
  EOT
}

variable "exclusions" {
  type = list(object({
    name        = string
    description = optional(string)
    filter      = string
    disable     = optional(bool, false)
  }))
  default     = []
  description = <<-EOT
    The exclusions to apply when exporting logs. Only log entries that match the filter are excluded.
    See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/advanced_filters) for information on how to write a filter.
  EOT
}

variable "pubsub_topic" {
  type = object({
    create                     = optional(bool, true)
    project_id                 = optional(string)
    name                       = optional(string)
    message_retention_duration = optional(string, "21600s")
    message_storage_policy = optional(object({
      allowed_persistence_regions = list(string)
      enforce_in_transit          = optional(bool, true)
    }))
    subscription = optional(object({
      name                       = optional(string, "ef-collector")
      ack_deadline_seconds       = optional(number)
      message_retention_duration = optional(string, "21600s")
      retain_acked_messages      = optional(bool, false)
      retry_policy = optional(object({
        minimum_backoff = optional(string, "10s")
        maximum_backoff = optional(string, "600s")
      }), {})
    }), {})
  })
  default     = {}
  description = <<-EOT
    The Pub/Sub topic attributes:
    * Default retention duration is 21600 seconds (6 hours).
    * If `name = null`, then `var.name` is used.
    * Set `retry_policy = null` to set the default retry policy ("Retry immediately").
    * Note, `message_storage_policy` is immutable, [upstream bug](https://github.com/hashicorp/terraform-provider-google/issues/20431). Topic taint is needed if you want to change it.
    * If `create = false`, then `project_id` must be set.
  EOT

  validation {
    condition     = (var.pubsub_topic.create == true || var.pubsub_topic.project_id != null)
    error_message = "If `create` is set to `false`, `project_id` must be set."
  }
}

variable "pubsub_topic_iam_members" {
  type = map(object({
    member = string
    role   = string
  }))
  default     = {}
  description = <<-EOT
    List of IAM members to grant access to the PubSub topic. Applicable if `var.pubsub_topic.create = true`.
    Example:
    ```hcl
    pubsub_topic_iam_members = {
      # Allow another-flow-src to publish to the topic
      some_publisher = { member = "serviceAccount:service-000000000000@gcp-sa-logging.iam.gserviceaccount.com", role = "roles/pubsub.publisher" },
    }
    ```
  EOT
}

variable "pubsub_topic_subscription_iam_members" {
  type = map(object({
    member = string
    role   = string
  }))
  default     = {}
  description = "List of IAM members to grant access to the PubSub topic subscription. Applicable if `var.pubsub_topic.create = true`."
}

variable "collector_service_account" {
  type = object({
    create       = optional(bool, true)
    name         = optional(string)
    display_name = optional(string)
    description  = optional(string, "ElastiFlow Collector Service Account")
  })
  default     = {}
  description = <<-EOT
    NetObserv collector service account:
    * Created only if `create` and `var.pubsub_topic.create` are set to `true`.
    * `name` is the [account_id attribute](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account#account_id-1) of the service account to create.
    * If `id = null`, `var.name` is be used.
  EOT
}
