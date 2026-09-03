variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    project     = "axion"
    environment = "dev"
    managed_by  = "terraform"
  }
}

variable "db_admin_username" {
  description = "Database administrator username"
  type        = string
  default     = "axionadmin"
}

variable "db_admin_password" {
  description = "Password for the PostgreSQL administrator"
  type        = string
  sensitive   = true
}

variable "jumpbox_admin_username" {
  description = "Admin username for the Azure jump VM"
  type        = string
  default     = "azureuser"
}

variable "jumpbox_admin_password" {
  description = "Secure password for the Azure jump VM admin account"
  type        = string
  sensitive   = true
}
