terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.98.1"
    }
  }
}

module "cloud_init" {
  source = "../proxmox_file_cloud_init"

  proxmox_node = { 
    name = var.proxmox_node.name
    snippets_datastore = var.proxmox_node.snippets_datastore
  }

  file_name = var.vm_spec.name

  default_user_name           = var.vm_spec.default_user_name
  default_user_ssh_public_key = var.vm_spec.default_user_public_key
  default_user_password_hash  = var.default_user_password_hash

  ansible_user_ssh_public_key = var.vm_spec.ansible_ssh_public_key
  ansible_user_password_hash  = var.ansible_user_password_hash
  }

module "vm" {
  source = "../proxmox_vm"
  
  proxmox_node = { 
    name = var.proxmox_node.name
    network_bridge = var.proxmox_node.network_bridge
    vm_datastore = var.proxmox_node.vm_datastore
  }
  
  spec =  { 
    name     = var.vm_spec.name
    hostname = var.vm_spec.hostname
    vm_id    = var.vm_spec.vm_id

    image_file_id = var.vm_spec.image_file_id

    cores     = var.vm_spec.cores
    memory    = var.vm_spec.memory
    disk_size = var.vm_spec.disk_size

    ipv4_config = { 
      gateway = var.vm_spec.ipv4_config.gateway
      address = var.vm_spec.ipv4_config.address
    }

    env_file_cloud_init_id = module.cloud_init.id
  }
}