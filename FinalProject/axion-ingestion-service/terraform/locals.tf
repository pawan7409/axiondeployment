locals {
  resource_groups = {
    axion = {
      name     = "rg-axion-${var.environment}"
      location = var.location
      tags     = var.tags
    }
  }

  vnets = {
    axion = {
      name          = "vnet-axion-${var.environment}"
      address_space = ["10.20.0.0/16"]
    }
  }

  subnets = {
    aks = {
      address_prefixes = ["10.20.1.0/24"]
    }
    private_endpoints = {
      address_prefixes = ["10.20.2.0/24"]
    }
    AzureBastionSubnet = {
      address_prefixes = ["10.20.3.0/26"]
    }
    jumpbox = {
      address_prefixes = ["10.20.4.0/24"]
    }
  }

  aks_clusters = {
    axion = {
      name       = "aks-axion-${var.environment}"
      dns_prefix = "axion-${var.environment}"
      node_count = 1
      vm_size    = "Standard_D2s_v3"
    }
  }

  database_servers = {
    axiondb = {
      name                  = "postgres-axion-${var.environment}"
      sku_name              = "GP_Standard_D2s_v3"
      version               = "15"
      storage_mb            = 32768
      admin_username        = var.db_admin_username
      admin_password        = var.db_admin_password
      zone                  = "1"
      backup_retention_days = 7
    }
  }

  bastion_hosts = {
    axion = {
      name = "bastion-axion-${var.environment}"
    }
  }

  jump_vms = {
    admin = {
      name = "vm-axion-admin-${var.environment}"
    }
  }

  acr_name = "acraxion${var.environment}"

  keyvault_name = "kvaxion${var.environment}"
  log_name      = "law-axion-${var.environment}"
}
