resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnet

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = each.value.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = keys(var.vnet)[0]
  address_prefixes     = each.value.address_prefixes

  depends_on = [azurerm_virtual_network.vnet]
}
