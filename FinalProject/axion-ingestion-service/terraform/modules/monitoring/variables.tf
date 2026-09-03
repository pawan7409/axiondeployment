variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workspaces" {
  description = "Map of Log Analytics workspaces"
  type = map(object({
    sku                = string
    retention_in_days  = number
    daily_quota_gb     = number
    internet_ingestion = bool
    internet_query     = bool
  }))
}

variable "tags" {
  type = map(string)
}
