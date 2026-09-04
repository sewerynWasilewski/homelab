resource "proxmox_virtual_environment_vm" "k8s_nodes" {
  for_each = local.k8s_nodes

  name        = each.key
  node_name   = each.value.pve_node_name
  vm_id       = each.value.vm_id
  description = each.value.description
  tags        = ["terraform", "k8s"]

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = var.proxmox_bridge
    model  = "virtio"
  }

  disk {
    datastore_id = var.proxmox_vm_datastore
    interface    = "scsi0"
    size         = each.value.disk
    iothread     = false
    discard      = "on"
    ssd          = true
  }

  initialization {
    datastore_id = var.proxmox_vm_datastore
    user_data_file_id = proxmox_virtual_environment_file.k8s_cloud_init[each.key].id

    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = each.value.gateway
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

