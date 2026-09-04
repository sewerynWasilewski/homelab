variable "proxmox_node" {
  type = object({
    name = string
    network_bridge = optional(string, "vmbr1")
    vm_datastore   = optional(string, "local-lvm")                   # "Datastore for VM disks, usually local-lvm"
  })
}

variable "started" {
  type = bool
  default = false
}

variable "enabled_agent" {
  type = bool
  default = false
}

variable "spec" {
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

    env_file_cloud_init_id = string
  })
}