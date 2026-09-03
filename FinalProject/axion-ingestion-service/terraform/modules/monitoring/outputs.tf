output "workspace_ids" {
  value = {
    for key, workspace in azurerm_log_analytics_workspace.law : key => workspace.id
  }
}
