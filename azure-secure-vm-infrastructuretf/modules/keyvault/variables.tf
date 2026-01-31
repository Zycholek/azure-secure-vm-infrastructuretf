
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "env" { 
 type = string
}

variable "vm_identities" {
  type = map(string)
  description = "Map of VM names to their managed identity object IDs"
}

variable "tags" {
  type = map(string)
}