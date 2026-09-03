variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "servers" {
  type = map(object({
    sku_name               = string
    version                = string
    storage_mb             = number
    admin_username         = string
    admin_password         = string
    zone                   = string
    backup_retention_days  = number
  }))
}

variable "tags" {
  type = map(string)
}
