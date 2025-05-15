package tests

import (
	"cloud.google.com/go/iam/apiv1/iampb"
)

type outputPubSubTopic struct {
	ID           string                         `json:"id"`
	Name         string                         `json:"name"`
	Project      string                         `json:"project"`
	Subscription *outputPubSubTopicSubscription `json:"subscription"`
}

type outputPubSubTopicSubscription struct {
	Project string `json:"project"`
	ID      string `json:"id"`
	Name    string `json:"name"`
}

type outputServiceAccount struct {
	Project string `json:"project"`
	ID      string `json:"id"`
	Name    string `json:"name"`
	Email   string `json:"email"`
	Member  string `json:"member"`
}

// Datasources types
type dataPubSubTopic struct {
	Project string `json:"project"`
	ID      string `json:"id"`
	Name    string `json:"name"`
}

type dataPubSubSubscription struct {
	Project            string `json:"project"`
	Name               string `json:"name"`
	AckDeadlineSeconds int    `json:"ack_deadline_seconds"`
	Topic              string `json:"topic"`
}

type dataLoggingSink struct {
	Project        string `json:"project"`
	Name           string `json:"name"`
	Filter         string `json:"filter"`
	Destination    string `json:"destination"`
	WriterIdentity string `json:"writer_identity"`
}

type dataPolicyData struct {
	Bindings []*iampb.Binding `json:"bindings"`
}

type dataServiceAccount struct {
	AccountID   string `json:"account_id"`
	Disabled    bool   `json:"disabled"`
	DisplayName string `json:"display_name"`
	Email       string `json:"email"`
	Member      string `json:"member"`
	Name        string `json:"name"`
	UniqueID    string `json:"unique_id"`
}

type dataServiceAccounts struct {
	ID       string               `json:"id"`
	Project  string               `json:"project"`
	Accounts []dataServiceAccount `json:"accounts"`
}
