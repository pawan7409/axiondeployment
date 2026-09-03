resource "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_postgresql_flexible_server" "db" {
  for_each = var.servers

  name                   = "${each.key}-${var.resource_group_name}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = each.value.version
  administrator_login    = each.value.admin_username
  administrator_password = each.value.admin_password
  zone                   = each.value.zone
  storage_mb             = each.value.storage_mb
  sku_name               = each.value.sku_name
  backup_retention_days  = each.value.backup_retention_days
  public_network_access_enabled = false
  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "db_link" {
  name                  = "db-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "db_pe" {
  for_each = var.servers

  name                = "${each.key}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${each.key}-psc"
    private_connection_resource_id = azurerm_postgresql_flexible_server.db[each.key].id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.postgres.id]
  }

  tags = var.tags
}
