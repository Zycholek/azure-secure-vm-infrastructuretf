variable "name" {
  description = "Container group name"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "container_name" {
  type = string
}


variable "acr_login_server" {
  description = "ACR login server (e.g. myacr.azurecr.io)"
  type        = string
}

variable "image_name" {
  description = "Container image name in ACR"
  type        = string
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

variable "port" {
  description = "Exposed container port"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "vCPU for container"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory (GB) for container"
  type        = number
  default     = 1.5
}

variable "dns_name_label" {
  type    = string
  default = null
}

variable "depends_on_role_assignment" {
  type    = any
  default = null
}

variable "acr_admin_username" {
  type = string
}

variable "acr_admin_password" {
  type = string
}