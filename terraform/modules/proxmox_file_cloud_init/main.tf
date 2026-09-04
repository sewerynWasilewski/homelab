terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.98.1"
    }
  }
}

resource "proxmox_virtual_environment_file" "this" {
  content_type = "snippets"
  datastore_id = var.proxmox_node.snippets_datastore
  node_name    = var.proxmox_node.name

  source_raw {
    file_name = "${var.file_name}-cloud-init.yaml"
    data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
      hostname = var.file_name
      
      default_user_name          = var.default_user_name
      default_user_public_key    = var.default_user_ssh_public_key
      default_user_password_hash = var.default_user_password_hash
      
      ansible_ssh_public_key = var.ansible_user_ssh_public_key
      ansible_password_hash  = var.ansible_user_password_hash

    })
  }
}