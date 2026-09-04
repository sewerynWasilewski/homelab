locals {
  k8s_nodes = {
    k8s-cp-01 = {
      vm_id         = 801
      cores         = 2
      memory        = 4096
      disk          = 30
      ip            = "10.10.10.81/24"
      gateway       = "10.10.10.1"
      description   = "Terraform control plane"
      pve_node_name = "proxmox01"
    }

    k8s-worker-01 = {
      vm_id         = 802
      cores         = 4
      memory        = 8192
      disk          = 40
      ip            = "10.10.10.82/24"
      gateway       = "10.10.10.1"
      description   = "Terraform worker 01"
      pve_node_name = "proxmox01"
    }

    k8s-worker-02 = {
      vm_id         = 803
      cores         = 4
      memory        = 8192
      disk          = 40
      ip            = "10.10.10.83/24"
      gateway       = "10.10.10.1"
      description   = "Terraform worker 02"
      pve_node_name = "proxmox01"
    }

    k8s-worker-03 = {
      vm_id         = 804
      cores         = 4
      memory        = 8192
      disk          = 40
      ip            = "10.10.10.84/24"
      gateway       = "10.10.10.1"
      description   = "Terraform worker 03"
      pve_node_name = "proxmox01"
    }
  }
}