output "k8s_nodes" {
  value = {
    for name, vm in proxmox_virtual_environment_vm.k8s_nodes : name => {
      vm_id = vm.vm_id
      name  = vm.name
    }
  }
}