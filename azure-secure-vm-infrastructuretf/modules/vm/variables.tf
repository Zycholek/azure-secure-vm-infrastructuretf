
variable "vm_name" {
    type = string
    description = "Name of the vm"
  
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


variable "subnet_id" {
  type = string
  description = "Subnet ID where the NIC will be placed."
}

variable "assign_public_ip" {
  type        = bool
  default     = false

  description = "Whether to create and attach a Public IP."
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
}









