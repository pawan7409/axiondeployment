output "vnet_id" {
  value = {
    for key, vnet in azurerm_virtual_network.vnet : key => vnet.id
  }
}

output "subnet_ids" {
  value = {
    for key, subnet in azurerm_subnet.subnets : key => subnet.id
  }
}
