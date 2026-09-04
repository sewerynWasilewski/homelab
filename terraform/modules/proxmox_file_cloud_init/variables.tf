variable "proxmox_node" {
  type = object({
    name = string
    snippets_datastore = optional(string, "local")
  })
}

variable "file_name" {
  type = string
}
    
variable "default_user_name" { 
  type = string
}
    
variable "default_user_ssh_public_key" { 
  type = string
}
    
variable "ansible_user_ssh_public_key" { 
  type = string
}

variable "default_user_password_hash" {
  type      = string
  sensitive = true
}

variable "ansible_user_password_hash" {
  type      = string
  sensitive = true
}
