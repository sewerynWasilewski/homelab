variable "proxmox_node" {
  type = object({
    name = string
    network_bridge = optional(string, "vmbr1") 
    iso_datastore  = optional(string, "local") # Datastore for ISO/cloud image upload, usually local
    image_content_type = optional(string, "iso")
    vm_datastore   = string                    # "Datastore for VM disks, usually local-lvm"
    snippets_datastore = optional(string, "local")
  })
}

variable "vm_spec" {
  type = object({
    name          = string
    hostname      = string
    vm_id         = number
    cores         = number
    memory        = number
    disk_size     = number
    image_file_id = string

    ipv4_config = object({
      gateway = string
      address = string
    })

    default_user_name          = string
    default_user_public_key    = string
    ansible_ssh_public_key     = string
  })
}

# kept outside base_vm variable for easier env variable injection
variable "default_user_password_hash" {
  type      = string
  sensitive = true
}

variable "ansible_user_password_hash" {
  type      = string
  sensitive = true
}
