variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet" {
  type = map(object({
    address_space = list(string)
  }))
}

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "tags" {
  type = map(string)
}
