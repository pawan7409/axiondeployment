module "resource_group" {
  source = "./modules/resource_group"

  resource_groups = local.resource_groups
}

module "networking" {
  source = "./modules/networking"

  resource_group_name = module.resource_group.resource_group_names["axion"]
  location            = var.location

  vnet = {
    for name, cfg in local.vnets : name => {
      address_space = cfg.address_space
    }
  }

  subnets = {
    for name, config in local.subnets : name => {
      address_prefixes = config.address_prefixes
    }
  }

  tags = var.tags
}

module "acr" {
  source = "./modules/acr"

  resource_group_name = module.resource_group.resource_group_names["axion"]
  location            = var.location
  acr_name            = local.acr_name
  tags                = var.tags
}

module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = module.resource_group.resource_group_names["axion"]
  location            = var.location

  workspaces = {
    axion = {
      sku                 = "PerGB2018"
      retention_in_days   = 30
      daily_quota_gb      = 0.5
      internet_ingestion  = true
      internet_query      = true
    }
  }

  tags = var.tags
}

module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = module.resource_group.resource_group_names["axion"]
  location            = var.location
  vault_name          = local.keyvault_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = var.tags
}

module "aks" {
  source = "./modules/aks"

  resource_group_name = module.resource_group.resource_group_names["axion"]
  location            = var.location
  cluster_name        = local.aks_clusters["axion"].name
  dns_prefix          = local.aks_clusters["axion"].dns_prefix
  subnet_id           = module.networking.subnet_ids["aks"]
  node_count          = local.aks_clusters["axion"].node_count
  vm_size             = local.aks_clusters["axion"].vm_size
  tags                = var.tags
}

module "postgresql" {
  source = "./modules/postgresql"

  resource_group_name = module.resource_group.resource_group_names["axion"]
  location            = var.location
  vnet_id             = module.networking.vnet_id["axion"]
  subnet_id           = module.networking.subnet_ids["private_endpoints"]

  servers = {
    for name, cfg in local.database_servers : name => {
      sku_name              = cfg.sku_name
      version               = cfg.version
      storage_mb            = cfg.storage_mb
      admin_username        = cfg.admin_username
      admin_password        = cfg.admin_password
      zone                  = cfg.zone
      backup_retention_days = cfg.backup_retention_days
    }
  }

  tags = var.tags
}

module "bastion" {
  source = "./modules/bastion"

  resource_group_name = module.resource_group.resource_group_names["axion"]
  location            = var.location
  bastion_name        = local.bastion_hosts["axion"].name
  subnet_id           = module.networking.subnet_ids["AzureBastionSubnet"]
  tags                = var.tags
}

module "jumpbox" {
  source = "./modules/jumpbox"

  resource_group_name = module.resource_group.resource_group_names["axion"]
  location            = var.location
  vm_name             = local.jump_vms["admin"].name
  subnet_id           = module.networking.subnet_ids["jumpbox"]
  admin_username      = var.jumpbox_admin_username
  admin_password      = var.jumpbox_admin_password
  tags                = var.tags
}

module "acr_pull_assignment" {
  source = "./modules/role_assignment"

  scope_id = module.acr.registry_id
  principal_id = module.aks.aks_identity_principal_id
  role_definition_name = "AcrPull"
}

data "azurerm_client_config" "current" {}
