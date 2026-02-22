variable "name" {
  description = "ACR name (must be globally unique)"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}
