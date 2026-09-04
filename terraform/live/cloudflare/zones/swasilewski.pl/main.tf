terraform {
  required_version = ">= 1.5.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }

  backend "pg" {
    schema_name = "cloudflare_zone_swasilewski_pl"
    /*PG_CONN_STR*/
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}