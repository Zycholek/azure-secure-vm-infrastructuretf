
variable "vm_names" {
  type = object({
    frontendvm = string
    backendvm  = string
  })
}

variable "resource_group_name" {
  type = string
}


variable "location" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}


variable "admin_ssh_public_key" {
  type = string
}



variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
}


variable "frontend_subnet_id" {
  type = string
}

variable "backend_subnet_id" {
  type = string
}






