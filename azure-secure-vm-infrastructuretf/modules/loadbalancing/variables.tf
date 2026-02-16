variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "env" {
  type = string
}

variable "frontend_nic_id" {
  type = string
}

variable "lb_name" {
  type = string
}

variable "public_ip_name" {
  type = string
}

variable "tags" {

  type = map(string)
  
}