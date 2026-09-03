resource "azurerm_log_analytics_workspace" "law" {
  for_each = var.workspaces

  name                = "${each.key}-law-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = each.value.sku
  retention_in_days   = each.value.retention_in_days
  daily_quota_gb      = each.value.daily_quota_gb
  internet_ingestion_enabled = each.value.internet_ingestion
  internet_query_enabled     = each.value.internet_query
  tags = var.tags
}
