terraform {
  required_version = ">= 1.5.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }

  backend "s3" {
    # State in MinIO on the services VM, see terraform/README.md.
    bucket                      = "tfstate"
    key                         = "cloudflare/zones/swasilewski.pl.tfstate"
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

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}