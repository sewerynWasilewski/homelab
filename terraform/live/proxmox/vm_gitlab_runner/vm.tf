module "vm_cloud_init" {
  source = "../../../modules/proxmox_vm_with_cloud_init"
  
  proxmox_node = { 
    name               = var.proxmox_node.name
    network_bridge     = var.proxmox_node.network_bridge
    vm_datastore       = var.proxmox_node.vm_datastore
    iso_datastore      = var.proxmox_node.iso_datastore
    snippets_datastore = var.proxmox_node.snippets_datastore
  }
  
  vm_spec =  { 
    name     = var.base_vm.name
    hostname = var.base_vm.hostname
    vm_id    = var.base_vm.vm_id

    image_file_id = var.base_vm.image_file_id

    cores     = var.base_vm.cores
    memory    = var.base_vm.memory
    disk_size = var.base_vm.disk_size

    ipv4_config = { 
      gateway = var.base_vm.ipv4_config.gateway
      address = var.base_vm.ipv4_config.address
    }

    ansible_ssh_public_key  = var.base_vm.ansible_ssh_public_key
    default_user_name       = var.base_vm.default_user_name
    default_user_public_key = var.base_vm.default_user_public_key
  }

  default_user_password_hash  = var.default_user_password_hash
  ansible_user_password_hash  = var.ansible_user_password_hash
}