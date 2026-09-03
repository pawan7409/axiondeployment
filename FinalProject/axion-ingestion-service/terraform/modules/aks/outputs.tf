output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "private_fqdn" {
  value = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "aks_identity_principal_id" {
  value = azurerm_user_assigned_identity.aks.principal_id
}
