output "resource_group_name" {
  value = module.resource_group.resource_group_names
}

output "vnet_name" {
  value = module.networking.vnet_id
}

output "subnet_ids" {
  value = module.networking.subnet_ids
}

output "aks_name" {
  value = module.aks.cluster_name
}

output "aks_private_fqdn" {
  value = module.aks.private_fqdn
}

output "postgresql_server_name" {
  value = module.postgresql.server_names
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "bastion_host_name" {
  value = module.bastion.bastion_name
}
