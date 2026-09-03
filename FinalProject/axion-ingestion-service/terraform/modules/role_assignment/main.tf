resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.scope_id
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id
}
