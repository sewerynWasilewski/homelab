locals {
  cloud_images = {
    ubuntu_2404 = {
      url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
      file_name    = "ubuntu-noble-cloudimg-amd64.img"
      content_type = "iso"
    }

    ubuntu_2204 = {
      url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      file_name    = "ubuntu-jammy-cloudimg-amd64.img"
      content_type = "iso"
    }

    debian_12 = {
      url          = "https://cdimage.debian.org/cdimage/archive/12.0.0/amd64/iso-cd/debian-12.0.0-amd64-netinst.iso"
      file_name    = "debian-12.0.0-amd64-netinst.iso"
      content_type = "iso"
    }
  }  
}

resource "proxmox_virtual_environment_download_file" "images" {
  for_each = local.cloud_images

  node_name    = var.proxmox_node_name
  datastore_id = var.image_datastore_id

  url          = each.value.url
  file_name    = each.value.file_name
  content_type = each.value.content_type

  overwrite            = false
  overwrite_unmanaged  = false
  verify               = true
}