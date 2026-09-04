variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_ssh_username" {
  type    = string
  default = "root"
}

variable "proxmox_node_name" {
  type = string
}

variable "image_datastore_id" {
  type = string
}