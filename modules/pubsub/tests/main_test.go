package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAllInOneFull(t *testing.T) {
	type outputs struct {
		name           string
		destination    string
		writerIdentity string
		pubSubTopic    *outputPubSubTopic
		serviceAccount *outputServiceAccount
	}

	testCases := []struct {
		name   string
		tfOpts *terraform.Options
		want   outputs
	}{
		{
			name:   "defaults",
			tfOpts: &terraform.Options{TerraformDir: "./all_in_one_full"},
			want: outputs{
				name:           "ef-collector",
				destination:    "pubsub.googleapis.com/projects/ef-test-a/topics/ef-collector",
				writerIdentity: "serviceAccount:service-210360456391@gcp-sa-logging.iam.gserviceaccount.com",
				pubSubTopic: &outputPubSubTopic{
					ID:      "projects/ef-test-a/topics/ef-collector",
					Name:    "ef-collector",
					Project: "ef-test-a",
					Subscription: &outputPubSubTopicSubscription{
						Project: "ef-test-a",
						ID:      "projects/ef-test-a/subscriptions/ef-collector",
						Name:    "ef-collector",
					},
				},
				serviceAccount: &outputServiceAccount{
					Project: "ef-test-a",
					ID:      "projects/ef-test-a/serviceAccounts/ef-collector@ef-test-a.iam.gserviceaccount.com",
					Name:    "projects/ef-test-a/serviceAccounts/ef-collector@ef-test-a.iam.gserviceaccount.com",
					Email:   "ef-collector@ef-test-a.iam.gserviceaccount.com",
					Member:  "serviceAccount:ef-collector@ef-test-a.iam.gserviceaccount.com",
				},
			},
		},
		{
			name:   "custom name",
			tfOpts: &terraform.Options{TerraformDir: "./all_in_one_full", Vars: map[string]interface{}{"name": "hildir"}},
			want: outputs{
				name:           "hildir",
				destination:    "pubsub.googleapis.com/projects/ef-test-a/topics/hildir",
				writerIdentity: "serviceAccount:service-210360456391@gcp-sa-logging.iam.gserviceaccount.com",
				pubSubTopic: &outputPubSubTopic{
					ID:      "projects/ef-test-a/topics/hildir",
					Name:    "hildir",
					Project: "ef-test-a",
					Subscription: &outputPubSubTopicSubscription{
						Project: "ef-test-a",
						ID:      "projects/ef-test-a/subscriptions/ef-collector",
						Name:    "ef-collector",
					},
				},
				serviceAccount: &outputServiceAccount{
					Project: "ef-test-a",
					ID:      "projects/ef-test-a/serviceAccounts/hildir@ef-test-a.iam.gserviceaccount.com",
					Name:    "projects/ef-test-a/serviceAccounts/hildir@ef-test-a.iam.gserviceaccount.com",
					Email:   "hildir@ef-test-a.iam.gserviceaccount.com",
					Member:  "serviceAccount:hildir@ef-test-a.iam.gserviceaccount.com",
				},
			},
		},
		{
			name: "custom service account name",
			tfOpts: &terraform.Options{TerraformDir: "./all_in_one_full", Vars: map[string]interface{}{
				"collector_service_account": map[string]interface{}{"name": "hjalmar"},
			}},
			want: outputs{
				name:           "ef-collector",
				destination:    "pubsub.googleapis.com/projects/ef-test-a/topics/ef-collector",
				writerIdentity: "serviceAccount:service-210360456391@gcp-sa-logging.iam.gserviceaccount.com",
				pubSubTopic: &outputPubSubTopic{
					ID:      "projects/ef-test-a/topics/ef-collector",
					Name:    "ef-collector",
					Project: "ef-test-a",
					Subscription: &outputPubSubTopicSubscription{
						Project: "ef-test-a",
						ID:      "projects/ef-test-a/subscriptions/ef-collector",
						Name:    "ef-collector",
					},
				},
				serviceAccount: &outputServiceAccount{
					Project: "ef-test-a",
					ID:      "projects/ef-test-a/serviceAccounts/hjalmar@ef-test-a.iam.gserviceaccount.com",
					Name:    "projects/ef-test-a/serviceAccounts/hjalmar@ef-test-a.iam.gserviceaccount.com",
					Email:   "hjalmar@ef-test-a.iam.gserviceaccount.com",
					Member:  "serviceAccount:hjalmar@ef-test-a.iam.gserviceaccount.com",
				},
			},
		},
		{
			name: "custom topic and subscription name",
			tfOpts: &terraform.Options{TerraformDir: "./all_in_one_full", Vars: map[string]interface{}{
				"pubsub_topic": map[string]interface{}{
					"name":         "cerys-the-collector",
					"subscription": map[string]interface{}{"name": "cerys-the-collector-sub"},
				},
			}},
			want: outputs{
				name:           "ef-collector",
				destination:    "pubsub.googleapis.com/projects/ef-test-a/topics/cerys-the-collector",
				writerIdentity: "serviceAccount:service-210360456391@gcp-sa-logging.iam.gserviceaccount.com",
				pubSubTopic: &outputPubSubTopic{
					ID:      "projects/ef-test-a/topics/cerys-the-collector",
					Name:    "cerys-the-collector",
					Project: "ef-test-a",
					Subscription: &outputPubSubTopicSubscription{
						Project: "ef-test-a",
						ID:      "projects/ef-test-a/subscriptions/cerys-the-collector-sub",
						Name:    "cerys-the-collector-sub",
					},
				},
				serviceAccount: &outputServiceAccount{
					Project: "ef-test-a",
					ID:      "projects/ef-test-a/serviceAccounts/ef-collector@ef-test-a.iam.gserviceaccount.com",
					Name:    "projects/ef-test-a/serviceAccounts/ef-collector@ef-test-a.iam.gserviceaccount.com",
					Email:   "ef-collector@ef-test-a.iam.gserviceaccount.com",
					Member:  "serviceAccount:ef-collector@ef-test-a.iam.gserviceaccount.com",
				},
			},
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			defer terraform.Destroy(t, tc.tfOpts)
			terraform.InitAndApply(t, tc.tfOpts)

			name := terraform.Output(t, tc.tfOpts, "name")
			destination := terraform.Output(t, tc.tfOpts, "destination")
			writerIdentity := terraform.Output(t, tc.tfOpts, "writer_identity")
			pubSubTopic := &outputPubSubTopic{}
			terraform.OutputStruct(t, tc.tfOpts, "pubsub_topic", pubSubTopic)
			serviceAccount := &outputServiceAccount{}
			terraform.OutputStruct(t, tc.tfOpts, "service_account", serviceAccount)

			assert.Equal(t, tc.want.name, name)
			assert.Equal(t, tc.want.destination, destination)
			assert.Equal(t, tc.want.writerIdentity, writerIdentity)
			assert.Equal(t, tc.want.pubSubTopic, pubSubTopic)
			assert.Equal(t, tc.want.serviceAccount, serviceAccount)
		})
	}
}

func TestTwoProjects(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "./two_projects",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Collector data
	pubSubTopicCollector := &dataPubSubTopic{}
	terraform.OutputStruct(t, terraformOptions, "pubsub_topic_collector", pubSubTopicCollector)
	pubSubSubscriptionCollector := &dataPubSubSubscription{}
	terraform.OutputStruct(t, terraformOptions, "pubsub_subscription_collector", pubSubSubscriptionCollector)
	loggingSinkCollector := &dataLoggingSink{}
	terraform.OutputStruct(t, terraformOptions, "logging_sink_collector", loggingSinkCollector)
	pubSubTopicIamPolicyCollector := &dataPolicyData{}
	terraform.OutputStruct(t, terraformOptions, "pubsub_topic_iam_policy_collector", pubSubTopicIamPolicyCollector)
	pubSubSubscriptionIamPolicyCollector := &dataPolicyData{}
	terraform.OutputStruct(t, terraformOptions, "pubsub_subscription_iam_policy_collector", pubSubSubscriptionIamPolicyCollector)

	// AnotherFlowSrc data
	loggingSinkAnotherFlowSrc := &dataLoggingSink{}
	terraform.OutputStruct(t, terraformOptions, "logging_sink_another_flow_src", loggingSinkAnotherFlowSrc)

	// "collector" resources
	assert.Equal(t, "ef-collector", loggingSinkCollector.Name)
	assert.Equal(t, `resource.type = "gce_subnetwork"`, loggingSinkCollector.Filter)
	assert.Equal(t, "pubsub.googleapis.com/projects/ef-test-a/topics/ef-collector", loggingSinkCollector.Destination)
	assert.Equal(t, "serviceAccount:service-210360456391@gcp-sa-logging.iam.gserviceaccount.com", loggingSinkCollector.WriterIdentity)
	assert.Equal(t, "ef-test-a", pubSubTopicCollector.Project)
	assert.Equal(t, "ef-collector", pubSubTopicCollector.Name)
	assert.Equal(t, 1, len(pubSubTopicIamPolicyCollector.Bindings))
	assert.Equal(t, "roles/pubsub.publisher", pubSubTopicIamPolicyCollector.Bindings[0].Role)
	assert.ElementsMatch(t,
		[]string{
			"serviceAccount:service-210360456391@gcp-sa-logging.iam.gserviceaccount.com",
			"serviceAccount:service-984014891511@gcp-sa-logging.iam.gserviceaccount.com",
		},
		pubSubTopicIamPolicyCollector.Bindings[0].Members,
	)

	assert.Equal(t, "ef-test-a", pubSubSubscriptionCollector.Project)
	assert.Equal(t, "ef-collector", pubSubSubscriptionCollector.Name)
	assert.Equal(t, 1, len(pubSubSubscriptionIamPolicyCollector.Bindings))
	assert.Equal(t, "roles/pubsub.subscriber", pubSubSubscriptionIamPolicyCollector.Bindings[0].Role)
	assert.ElementsMatch(t,
		[]string{
			"serviceAccount:ef-collector@ef-test-a.iam.gserviceaccount.com",
			"serviceAccount:tf-test@ef-test-a.iam.gserviceaccount.com",
		},
		pubSubSubscriptionIamPolicyCollector.Bindings[0].Members,
	)

	// "another slow src" resources
	assert.Equal(t, "ef-collector", loggingSinkAnotherFlowSrc.Name)
	assert.Equal(t, `resource.type = "gce_subnetwork"`, loggingSinkAnotherFlowSrc.Filter)
	assert.Equal(t, "pubsub.googleapis.com/projects/ef-test-a/topics/ef-collector", loggingSinkAnotherFlowSrc.Destination)
	assert.Equal(t, "serviceAccount:service-984014891511@gcp-sa-logging.iam.gserviceaccount.com", loggingSinkAnotherFlowSrc.WriterIdentity)
}

func TestThreeProjects(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "./three_projects",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// CollectorTopic data
	pubSubTopicCollectorTopic := &dataPubSubTopic{}
	terraform.OutputStruct(t, terraformOptions, "pubsub_topic_collector_topic", pubSubTopicCollectorTopic)
	pubSubSubscriptionCollectorTopic := &dataPubSubSubscription{}
	terraform.OutputStruct(t, terraformOptions, "pubsub_subscription_collector_topic", pubSubSubscriptionCollectorTopic)
	loggingSinkCollectorTopic := &dataLoggingSink{}
	terraform.OutputStruct(t, terraformOptions, "logging_sink_collector_topic", loggingSinkCollectorTopic)
	pubSubTopicIamPolicyCollectorTopic := &dataPolicyData{}
	terraform.OutputStruct(t, terraformOptions, "pubsub_topic_iam_policy_collector_topic", pubSubTopicIamPolicyCollectorTopic)
	pubSubSubscriptionIamPolicyCollectorTopic := &dataPolicyData{}
	terraform.OutputStruct(t, terraformOptions, "pubsub_subscription_iam_policy_collector_topic", pubSubSubscriptionIamPolicyCollectorTopic)
	serviceAccountsCollectorTopic := &dataServiceAccounts{}
	terraform.OutputStruct(t, terraformOptions, "google_service_accounts_collector_topic", serviceAccountsCollectorTopic)

	// AnotherFlowSrc data
	loggingSinkAnotherFlowSrc := &dataLoggingSink{}
	terraform.OutputStruct(t, terraformOptions, "logging_sink_another_flow_src", loggingSinkAnotherFlowSrc)

	// "collector" resources
	assert.Equal(t, "ef-collector", loggingSinkCollectorTopic.Name)
	assert.Equal(t, `resource.type = "gce_subnetwork"`, loggingSinkCollectorTopic.Filter)
	assert.Equal(t, "pubsub.googleapis.com/projects/ef-test-b/topics/ef-collector", loggingSinkCollectorTopic.Destination)
	assert.Equal(t, "serviceAccount:service-984014891511@gcp-sa-logging.iam.gserviceaccount.com", loggingSinkCollectorTopic.WriterIdentity)
	assert.Equal(t, "ef-test-b", pubSubTopicCollectorTopic.Project)
	assert.Equal(t, "ef-collector", pubSubTopicCollectorTopic.Name)
	assert.Equal(t, 1, len(pubSubTopicIamPolicyCollectorTopic.Bindings))
	assert.Equal(t, "roles/pubsub.publisher", pubSubTopicIamPolicyCollectorTopic.Bindings[0].Role)
	assert.ElementsMatch(t,
		[]string{
			"serviceAccount:service-984014891511@gcp-sa-logging.iam.gserviceaccount.com",
			"serviceAccount:service-229460026857@gcp-sa-logging.iam.gserviceaccount.com",
		},
		pubSubTopicIamPolicyCollectorTopic.Bindings[0].Members,
	)

	assert.Equal(t, "ef-test-b", pubSubSubscriptionCollectorTopic.Project)
	assert.Equal(t, "ef-collector", pubSubSubscriptionCollectorTopic.Name)
	assert.Equal(t, 1, len(pubSubSubscriptionIamPolicyCollectorTopic.Bindings))
	assert.Equal(t, "roles/pubsub.subscriber", pubSubSubscriptionIamPolicyCollectorTopic.Bindings[0].Role)
	assert.ElementsMatch(t,
		[]string{
			"serviceAccount:ef-collector@ef-test-a.iam.gserviceaccount.com",
		},
		pubSubSubscriptionIamPolicyCollectorTopic.Bindings[0].Members,
	)

	serviceAccounts := []string{}
	for _, i := range serviceAccountsCollectorTopic.Accounts {
		serviceAccounts = append(serviceAccounts, i.AccountID)
	}
	assert.NotContains(t, serviceAccounts, "ef-collector")

	// "another slow src" resources
	assert.Equal(t, "ef-collector", loggingSinkAnotherFlowSrc.Name)
	assert.Equal(t, `resource.type = "gce_subnetwork"`, loggingSinkAnotherFlowSrc.Filter)
	assert.Equal(t, "pubsub.googleapis.com/projects/ef-test-b/topics/ef-collector", loggingSinkAnotherFlowSrc.Destination)
	assert.Equal(t, "serviceAccount:service-229460026857@gcp-sa-logging.iam.gserviceaccount.com", loggingSinkAnotherFlowSrc.WriterIdentity)
}
