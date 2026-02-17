# General

variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}


# Networking. 


variable "location" {
  type        = string
  description = "Azure region where resources will be deployed."

}

variable "my_ip" {
  type        = string
  description = "My public IP address in CIDR notation"
}

variable "vnet_address_space" {
  type = list(string)
}


variable "frontend_subnet_prefix" {
  type = list(string)
}

variable "backend_subnet_prefix" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}


# VMS info

variable "vm_names" {
  type = object({
    frontendvm = string
    backendvm  = string
  })
}

variable "admin_username" {
  type = string

}

variable "vm_size" {
  type    = string
  default = "Standard_D2as_v7"
}

# For keyvault module calling


variable "key_vault_name" {
  type = string
}

variable "env" {
  type = string
}

# Monitoring

variable "log_analytics_name" {
  type = string
}


# LoadBalancing


variable "lb_name" {
  type = string
}

variable "public_ip_name" {
  type = string
}


