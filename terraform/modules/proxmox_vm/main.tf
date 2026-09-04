terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.98.1"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name        = var.spec.name
  #description = ""
  tags        = ["tf"]

  node_name = var.proxmox_node.name
  vm_id     = var.spec.vm_id
  started   = var.started
  template  = false 

  stop_on_destroy = true

  agent {
    enabled = var.enabled_agent
  }

  cpu {
    cores = var.spec.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.spec.memory
    floating  = var.spec.memory
  }

  network_device {
    bridge = var.proxmox_node.network_bridge
    model  = "virtio"
  }

  disk {
    datastore_id = var.proxmox_node.vm_datastore
    interface    = "scsi0"
    file_id      = var.spec.image_file_id 
    iothread     = true
    discard      = "on"
    ssd          = true
    size         = var.spec.disk_size
  }

  initialization {
    datastore_id = var.proxmox_node.vm_datastore
    user_data_file_id = var.spec.env_file_cloud_init_id

    ip_config {
      ipv4 {
        address = var.spec.ipv4_config.address
        gateway = var.spec.ipv4_config.gateway
      }
    }
  }

  operating_system {
    type = "l26"
  }

  serial_device {}
  vga {
    type = "serial0"
  }

  boot_order = ["scsi0"]
}