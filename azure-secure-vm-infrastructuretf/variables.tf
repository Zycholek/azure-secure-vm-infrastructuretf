
#Authentication (service principal/app registration)

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "client_id" {
  type        = string
  description = "Azure client ID (App Registration)"
}

variable "client_secret" {
  type        = string
  description = "Azure client secret"
  sensitive   = true
}


# Need to put all the IP addresses in variables and then in .tfvars. 


variable "location" {
  type = string
  description = "Azure region where resources will be deployed."
  
}


variable "my_ip" {
  type        = string
  description = "My public IP address in CIDR notation"
}

variable "vnet_address_space" {
  type = list(string)
}



  


