# two_projects

Testing module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 6.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google.another-flow-src"></a> [google.another-flow-src](#provider\_google.another-flow-src) | 6.18.0 |
| <a name="provider_google.collector"></a> [google.collector](#provider\_google.collector) | 6.18.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_another_flow_src"></a> [another\_flow\_src](#module\_another\_flow\_src) | ../../ | n/a |
| <a name="module_collector"></a> [collector](#module\_collector) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [google_logging_sink.another_flow_src](https://registry.terraform.io/providers/hashicorp/google/6.18.0/docs/data-sources/logging_sink) | data source |
| [google_logging_sink.collector](https://registry.terraform.io/providers/hashicorp/google/6.18.0/docs/data-sources/logging_sink) | data source |
| [google_project.another_flow_src](https://registry.terraform.io/providers/hashicorp/google/6.18.0/docs/data-sources/project) | data source |
| [google_project.collector](https://registry.terraform.io/providers/hashicorp/google/6.18.0/docs/data-sources/project) | data source |
| [google_pubsub_subscription.collector](https://registry.terraform.io/providers/hashicorp/google/6.18.0/docs/data-sources/pubsub_subscription) | data source |
| [google_pubsub_subscription_iam_policy.collector](https://registry.terraform.io/providers/hashicorp/google/6.18.0/docs/data-sources/pubsub_subscription_iam_policy) | data source |
| [google_pubsub_topic.collector](https://registry.terraform.io/providers/hashicorp/google/6.18.0/docs/data-sources/pubsub_topic) | data source |
| [google_pubsub_topic_iam_policy.collector](https://registry.terraform.io/providers/hashicorp/google/6.18.0/docs/data-sources/pubsub_topic_iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ef_test_a"></a> [ef\_test\_a](#input\_ef\_test\_a) | Configuration for ef\_test\_a provider | <pre>object({<br/>    project_id                  = string<br/>    impersonate_service_account = string<br/>  })</pre> | n/a | yes |
| <a name="input_ef_test_b"></a> [ef\_test\_b](#input\_ef\_test\_b) | Configuration for ef\_test\_a provider | <pre>object({<br/>    project_id                  = string<br/>    impersonate_service_account = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logging_sink_another_flow_src"></a> [logging\_sink\_another\_flow\_src](#output\_logging\_sink\_another\_flow\_src) | terratest output |
| <a name="output_logging_sink_collector"></a> [logging\_sink\_collector](#output\_logging\_sink\_collector) | terratest output |
| <a name="output_pubsub_subscription_collector"></a> [pubsub\_subscription\_collector](#output\_pubsub\_subscription\_collector) | terratest output |
| <a name="output_pubsub_subscription_iam_policy_collector"></a> [pubsub\_subscription\_iam\_policy\_collector](#output\_pubsub\_subscription\_iam\_policy\_collector) | terratest output |
| <a name="output_pubsub_topic_collector"></a> [pubsub\_topic\_collector](#output\_pubsub\_topic\_collector) | terratest output |
| <a name="output_pubsub_topic_iam_policy_collector"></a> [pubsub\_topic\_iam\_policy\_collector](#output\_pubsub\_topic\_iam\_policy\_collector) | terratest output |
<!-- END_TF_DOCS -->
