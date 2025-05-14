# all_in_one_full

Testing module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 6.18.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_collector_service_account"></a> [collector\_service\_account](#input\_collector\_service\_account) | NetObserv collector service account:<br/>* Created only if `create` and `var.pubsub_topic.create` is set to `true`.<br/>* `name` is the [account\_id attribute](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account#account_id-1) of the service account to create.<br/>* If `id = null`, `var.name` is be used. | <pre>object({<br/>    create       = optional(bool, true)<br/>    name         = optional(string)<br/>    display_name = optional(string)<br/>    description  = optional(string, "ElastiFlow Collector Service Account")<br/>  })</pre> | `{}` | no |
| <a name="input_ef_test_a"></a> [ef\_test\_a](#input\_ef\_test\_a) | Configuration for ef\_test\_a provider | <pre>object({<br/>    project_id                  = string<br/>    impersonate_service_account = string<br/>  })</pre> | n/a | yes |
| <a name="input_exclusions"></a> [exclusions](#input\_exclusions) | The exclusions to apply when exporting logs. Only log entries that match the filter are excluded.<br/>See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/advanced_filters) for information on how to write a filter. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string)<br/>    filter      = string<br/>    disable     = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_filter"></a> [filter](#input\_filter) | The filter to apply when exporting logs. Only log entries that match the filter are exported.<br/>See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/advanced_filters) for information on how to write a filter. | `string` | `"resource.type = \"gce_subnetwork\""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels to all applicable resources. | `map(string)` | <pre>{<br/>  "app": "ef-collector"<br/>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Google project-level logging sink.<br/>Used as a name in all other resources if individual names are not provided. | `string` | `"ef-collector"` | no |
| <a name="input_pubsub_topic"></a> [pubsub\_topic](#input\_pubsub\_topic) | The Pub/Sub topic attributes:<br/>* Default retention duration is 21600 seconds (6 hours).<br/>* If `name = null`, `var.name` is be used.<br/>* Set `retry_policy = null` to set the default retry policy ("Retry immediately").<br/>* Note, `message_storage_policy` is immutable, [upstream bug](https://github.com/hashicorp/terraform-provider-google/issues/20431). Topic taint is needed if you want to change it.<br/>* If `create = false`, `project_id` must be set | <pre>object({<br/>    create                     = optional(bool, true)<br/>    project_id                 = optional(string)<br/>    name                       = optional(string)<br/>    message_retention_duration = optional(string, "21600s")<br/>    message_storage_policy = optional(object({<br/>      allowed_persistence_regions = list(string)<br/>      enforce_in_transit          = optional(bool, true)<br/>    }))<br/>    subscription = optional(object({<br/>      name                       = optional(string, "ef-collector")<br/>      ack_deadline_seconds       = optional(number)<br/>      message_retention_duration = optional(string, "21600s")<br/>      retain_acked_messages      = optional(bool, false)<br/>      retry_policy = optional(object({<br/>        minimum_backoff = optional(string, "10s")<br/>        maximum_backoff = optional(string, "600s")<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_pubsub_topic_iam_members"></a> [pubsub\_topic\_iam\_members](#input\_pubsub\_topic\_iam\_members) | List of IAM members to grant access to the PubSub topic. Applicable if `var.pubsub_topic.create = true`.<br/>Example:<pre>hcl<br/>pubsub_topic_iam_members = {<br/>  # Allow another-flow-src to publish to the topic<br/>  some_publisher = { member = "serviceAccount:service-000000000000@gcp-sa-logging.iam.gserviceaccount.com", role = "roles/pubsub.publisher" },<br/>}</pre> | <pre>map(object({<br/>    member = string<br/>    role   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_pubsub_topic_subscription_iam_members"></a> [pubsub\_topic\_subscription\_iam\_members](#input\_pubsub\_topic\_subscription\_iam\_members) | List of IAM members to grant access to the PubSub topic subscription. Applicable if `var.pubsub_topic.create = true`. | <pre>map(object({<br/>    member = string<br/>    role   = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination"></a> [destination](#output\_destination) | terratest output |
| <a name="output_name"></a> [name](#output\_name) | terratest output |
| <a name="output_pubsub_topic"></a> [pubsub\_topic](#output\_pubsub\_topic) | terratest output |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | terratest output |
| <a name="output_writer_identity"></a> [writer\_identity](#output\_writer\_identity) | terratest output |
<!-- END_TF_DOCS -->
