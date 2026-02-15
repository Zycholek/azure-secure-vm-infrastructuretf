variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "env" {
  type = string
}

variable "retention_in_days" {
    type = number
    default = 30
}

variable "vm_ids" {
  type = map(string)
}

variable "key_vault_id" {
  type = string
}

variable "nsg_ids" {
  type = map(string)
}

variable "vnet_id" {
    type = string
}