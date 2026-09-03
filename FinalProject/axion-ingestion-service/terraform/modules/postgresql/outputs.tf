output "server_names" {
  value = {
    for key, server in azurerm_postgresql_flexible_server.db : key => server.name
  }
}

output "server_ids" {
  value = {
    for key, server in azurerm_postgresql_flexible_server.db : key => server.id
  }
}
