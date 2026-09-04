resource "proxmox_virtual_environment_file" "k8s_cloud_init" {
  for_each = local.k8s_nodes

  content_type = "snippets"
  datastore_id = var.proxmox_snippets_datastore
  node_name    = each.value.pve_node_name

  source_raw {
    file_name = "${each.key}-cloud-init.yaml"
    data = templatefile("${path.module}/cloud-init/cloud-init.yaml.tftpl", {
      hostname = each.key
      
      ubuntu_ssh_public_key  = var.ubuntu_ssh_public_key
      ubuntu_password_hash   = var.ubuntu_user_password_hash
      
      ansible_ssh_public_key = var.ansible_ssh_public_key
      ansible_password_hash  = var.ansible_user_password_hash
    })
  }
}