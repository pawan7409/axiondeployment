output "bastion_name" {
  value = azurerm_bastion_host.bastion.name
}

output "public_ip" {
  value = azurerm_public_ip.bastion.ip_address
}
