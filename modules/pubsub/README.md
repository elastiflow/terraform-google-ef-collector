- [Overview](#overview)
- [Examples](#examples)
  - [All in one project](#all-in-one-project)
  - [Two projects](#two-projects)
  - [Three projects](#three-projects)
- [Tests](#tests)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Overview

This terraform module is used to configure [GCP flow logs](https://cloud.google.com/vpc/docs/flow-logs) exports from Cloud Logging to a [PubSub topic](https://cloud.google.com/logging/docs/export/configure_export_v2#overview) to be consumed by ElastiFlow Collector

This module allows you to provision GCP resources in both simple (all resources in a single project) and distributed (multiple logging sinks, single topic) ways.

## Examples

### All in one project

All GCP resources required for the collector are co-located in a single project:

- PubSub topic
- Cloud Logging sink
- ElastiFlow Collector service account

```hcl
module "ef_collector" {
  source  = "elastiflow/ef-collector/google//pubsub"
  version = "~> 0.1"

  project_id = "some_google_project_id"
}
```

### Two projects

This example covers the use-case of a single Pub/Sub topic and N+1 Cloud Logging sinks.

Resources provisioned:

- "collector" project contains:
  - PubSub topic
  - Cloud Logging sink for this project
  - ElastiFlow Collector service account
- "another-flow-src" project contains:
  - Cloud Logging sink for this project with destination set to the "collector" PubSub topic

Note, [terraform dependencies](https://developer.hashicorp.com/terraform/tutorials/configuration-language/dependencies) were not used in the example on purpose, to demonstrate the `pubsub_topic_iam_members` values.

```hcl
data "google_project" "collector" { provider = google.collector }
data "google_project" "another_flow_src" { provider = google.another-flow-src }

module "collector" {
  source  = "elastiflow/tf-module-ef-collector-gcp//pubsub"
  version = "~> 0.1"

  providers = {
    google = google.collector
  }

  project_id = data.google_project.collector.project_id
  pubsub_topic_iam_members = [
    # Allow another-flow-src logging identity to publish to the topic
    { member = "serviceAccount:service-984014891511@gcp-sa-logging.iam.gserviceaccount.com", role = "roles/pubsub.publisher" },
  ]
}

module "another_flow_src" {
  source  = "elastiflow/tf-module-ef-collector-gcp//pubsub"
  version = "~> 0.1"

  providers = {
    google = google.another-flow-src
  }

  project_id = data.google_project.another_flow_src.project_id
  pubsub_topic = {
    create     = false
    project_id = data.google_project.collector.project_id
  }
}
```

### Three projects

This example covers the use-case of a single Pub/Sub topic, N+1 Cloud Logging sinks, and a collector service account in a separate project.

Resources provisioned:

- "collector-auth" project contains:
  - ElastiFlow Collector service account
- "collector-topic" project contains:
  - PubSub topic
  - Cloud Logging sink for this project
- "another-flow-src" project contains:
  - Cloud Logging sink for this project with destination set to the "collector" PubSub topic

It may be useful when:

- ElastiFlow Collector is deployed outside of the GCP, requires Service Account private key for authentication purposes
- GCP Organization policy prevents creating the private key for the Service Account
- Exception can be made for a particular GCP project that holds Service Accounts with private keys

```hcl
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
  source  = "elastiflow/ef-collector/google//pubsub"
  version = "~> 0.1"

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
  source  = "elastiflow/ef-collector/google//pubsub"
  version = "~> 0.1"

  providers = {
    google = google.another-flow-src
  }

  project_id = data.google_project.another_flow_src.project_id
  pubsub_topic = {
    create     = false
    project_id = data.google_project.collector_topic.project_id
  }
}
```

## Tests

In order to run the tests please copy the `**/vars.auto.tfvars.sample` and fill with proper values, than run `make test-integration`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.18 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.18 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_logging_project_sink.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) | resource |
| [google_pubsub_subscription.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | resource |
| [google_pubsub_subscription_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription_iam_member) | resource |
| [google_pubsub_subscription_iam_member.this_ef_collector](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription_iam_member) | resource |
| [google_pubsub_topic.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_pubsub_topic_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [google_pubsub_topic_iam_member.this_logging_sink_publisher](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [google_service_account.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_collector_service_account"></a> [collector\_service\_account](#input\_collector\_service\_account) | NetObserv collector service account:<br/>* Created only if `create` and `var.pubsub_topic.create` is set to `true`.<br/>* `name` is the [account\_id attribute](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account#account_id-1) of the service account to create.<br/>* If `id = null`, `var.name` is be used. | <pre>object({<br/>    create       = optional(bool, true)<br/>    name         = optional(string)<br/>    display_name = optional(string)<br/>    description  = optional(string, "ElastiFlow Collector Service Account")<br/>  })</pre> | `{}` | no |
| <a name="input_exclusions"></a> [exclusions](#input\_exclusions) | The exclusions to apply when exporting logs. Only log entries that match the filter are excluded.<br/>See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/advanced_filters) for information on how to write a filter. | <pre>list(object({<br/>    name        = string<br/>    description = optional(string)<br/>    filter      = string<br/>    disable     = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_filter"></a> [filter](#input\_filter) | The filter to apply when exporting logs. Only log entries that match the filter are exported.<br/>See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/advanced_filters) for information on how to write a filter. | `string` | `"resource.type = \"gce_subnetwork\""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels to all applicable resources. | `map(string)` | <pre>{<br/>  "app": "ef-collector"<br/>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Google project-level logging sink.<br/>Used as a name in all other resources if individual names are not provided. | `string` | `"ef-collector"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project where flow | `string` | n/a | yes |
| <a name="input_pubsub_topic"></a> [pubsub\_topic](#input\_pubsub\_topic) | The Pub/Sub topic attributes:<br/>* Default retention duration is 21600 seconds (6 hours).<br/>* If `name = null`, `var.name` is be used.<br/>* Set `retry_policy = null` to set the default retry policy ("Retry immediately").<br/>* Note, `message_storage_policy` is immutable, [upstream bug](https://github.com/hashicorp/terraform-provider-google/issues/20431). Topic taint is needed if you want to change it.<br/>* If `create = false`, `project_id` must be set | <pre>object({<br/>    create                     = optional(bool, true)<br/>    project_id                 = optional(string)<br/>    name                       = optional(string)<br/>    message_retention_duration = optional(string, "21600s")<br/>    message_storage_policy = optional(object({<br/>      allowed_persistence_regions = list(string)<br/>      enforce_in_transit          = optional(bool, true)<br/>    }))<br/>    subscription = optional(object({<br/>      name                       = optional(string, "ef-collector")<br/>      ack_deadline_seconds       = optional(number)<br/>      message_retention_duration = optional(string, "21600s")<br/>      retain_acked_messages      = optional(bool, false)<br/>      retry_policy = optional(object({<br/>        minimum_backoff = optional(string, "10s")<br/>        maximum_backoff = optional(string, "600s")<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_pubsub_topic_iam_members"></a> [pubsub\_topic\_iam\_members](#input\_pubsub\_topic\_iam\_members) | List of IAM members to grant access to the PubSub topic. Applicable if `var.pubsub_topic.create = true`.<br/>Example:<pre>hcl<br/>pubsub_topic_iam_members = {<br/>  # Allow another-flow-src to publish to the topic<br/>  some_publisher = { member = "serviceAccount:service-000000000000@gcp-sa-logging.iam.gserviceaccount.com", role = "roles/pubsub.publisher" },<br/>}</pre> | <pre>map(object({<br/>    member = string<br/>    role   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_pubsub_topic_subscription_iam_members"></a> [pubsub\_topic\_subscription\_iam\_members](#input\_pubsub\_topic\_subscription\_iam\_members) | List of IAM members to grant access to the PubSub topic subscription. Applicable if `var.pubsub_topic.create = true`. | <pre>map(object({<br/>    member = string<br/>    role   = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination"></a> [destination](#output\_destination) | The destination of the Google project-level logging sink |
| <a name="output_name"></a> [name](#output\_name) | The name of the Google project-level logging sink |
| <a name="output_pubsub_topic"></a> [pubsub\_topic](#output\_pubsub\_topic) | Attributes of the provisioned Pub/Sub topic and subscription |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Attributes of the provisioned service account, to be used in the ElastiFlow Collector |
| <a name="output_writer_identity"></a> [writer\_identity](#output\_writer\_identity) | The writer identity of the Google project-level logging sink |
<!-- END_TF_DOCS -->
