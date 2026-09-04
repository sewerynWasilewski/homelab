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

variable "proxmox_vm_datastore" {
  type = string
}

variable "proxmox_bridge" {
  type    = string
  default = "vmbr0"
}

variable "template_vm_id" {
  type = number
}

variable "proxmox_snippets_datastore" {
  type    = string
  default = "local"
}

variable "kubernetes_version" {
  type    = string
  default = "v1.29"
}

variable "ubuntu_ssh_public_key" {
  type = string
}

variable "ansible_ssh_public_key" {
  type = string
}

variable "ubuntu_user_password_hash" {
  type      = string
  sensitive = true
}

variable "ansible_user_password_hash" {
  type      = string
  sensitive = true
}