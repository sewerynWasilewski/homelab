terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.98.1"
    }
  }

  backend "s3" {
    # State in MinIO on the services VM, see terraform/README.md.
    bucket                      = "tfstate"
    key                         = "proxmox/vm_images.tfstate"
    region                      = "us-east-1"
    profile                     = "homelab-tfstate"
    endpoints                   = { s3 = "https://s3.swasilewski.pl" }
    use_path_style              = true
    use_lockfile                = true
    workspace_key_prefix        = "workspaces"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}

provider "proxmox" {
  endpoint = var.proxmox_api_url

  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"

  insecure = true

  ssh {
    agent    = true
    username = var.proxmox_ssh_username
  }
}