# Axion Terraform Architecture

This folder contains a Terraform layout for the Axion final project using:

- Azure Resource Group
- Private AKS cluster
- Azure Container Registry
- PostgreSQL Flexible Server
- Azure Bastion
- Jump VM for private access
- Key Vault
- Log Analytics
- Network isolation with private endpoints and private DNS

## Folder structure

- `main.tf` - calls each module
- `variables.tf` - shared variables
- `locals.tf` - common values
- `providers.tf` - Terraform and Azure provider configuration
- `outputs.tf` - useful outputs
- `modules/` - resource-specific modules

## Module map

- `resource_group` -> Resource Group creation
- `networking` -> VNet and subnets
- `acr` -> Azure Container Registry
- `aks` -> Private AKS cluster
- `postgresql` -> PostgreSQL Flexible Server + private endpoint
- `bastion` -> Azure Bastion
- `jumpbox` -> Admin VM for private access
- `keyvault` -> Secrets storage
- `monitoring` -> Log Analytics / monitoring

## Notes

This is a secure private-cluster design where the AKS control plane and database are private, and admin access is done through Azure Bastion and a jump VM.
