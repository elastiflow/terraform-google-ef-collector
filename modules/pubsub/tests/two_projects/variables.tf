variable "ef_test_a" {
  type = object({
    project_id                  = string
    impersonate_service_account = string
  })
  description = "Configuration for ef_test_a provider"
}

variable "ef_test_b" {
  type = object({
    project_id                  = string
    impersonate_service_account = string
  })
  description = "Configuration for ef_test_a provider"
}
