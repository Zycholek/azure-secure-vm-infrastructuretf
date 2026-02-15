# General


variable "resource_group_name" {
  type        = string
  description = "Resource group where networking resources will be created."
}

variable "location" {
  type        = string
  description = "Azure region for networking resources."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the virtual network."
}



variable "my_ip" {
  type        = string
  description = "Your public IP address in CIDR notation for SSH access."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
}

variable "frontend_subnet_prefix" {
  type        = list(string)
  description = "Address prefix for the frontend subnet"
}

variable "frontend_subnet_prefix" {
  type        = list(string)
  description = "Address prefix for the frontend subnet"
}

variable "backend_subnet_prefix" {
  type        = list(string)
  description = "Address prefix for the backend subnet"
}

