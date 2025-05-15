- [Overview](#overview)

## Overview

This repository contains the Terraform modules to configure NetObserv ElastiFlow Collector resources in GCP.

- `modules/pubsub` - configure resources for the [GCP flow logs](https://cloud.google.com/vpc/docs/flow-logs) exports from Cloud Logging to the [GCP Pub/Sub](https://cloud.google.com/pubsub/docs/overview) service to be consumed by ElastiFlow Collector
