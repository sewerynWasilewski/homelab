output "downloaded_images" {
  value = {
    for name, image in proxmox_virtual_environment_download_file.images :
    name => {
      file_name = image.file_name
      id        = image.id
    }
  }
}