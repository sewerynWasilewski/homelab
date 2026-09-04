locals {
  cf_account_id = "f623c5bf7694eaab9fae89043252c3d7"
  cf_zone_id = "5623694ab2d9be8a09eb3dfbd4d92300"

  cf_dns_records = {
    "apex_a" = { 
      content  = "46.62.184.91"
      name     = "@"
      proxied  = true
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - root"
    },
    "proxmox_a" = {
      content = "46.62.184.91"
      name     = "proxmox"
      proxied  = false
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - proxmox web panel"
    },
    "www_a" = { 
      content  = "46.62.184.91"
      name     = "www"
      proxied  = true
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform maaged - www webiste"
    }, 
    "photos_a" = { 
      content  = "46.62.184.91"
      name     = "photos"
      proxied  = true
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - Immich web panel"
    }, 
    "container_registry_a" = { 
      content  = "46.62.184.91"
      name     = "registry"
      proxied  = true
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - container registry"
    }, 
    "container_registry_ui_a" = { 
      content  = "46.62.184.91"
      name     = "registry-ui"
      proxied  = true
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - container registry ui - web panel"
    }, 
    "minio_s3_a" = { 
      content  = "46.62.184.91"
      name     = "s3"
      proxied  = true
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - minio s3 api endpoint"
    }, 
    "minio_web_panel_a" = { 
      content  = "46.62.184.91"
      name     = "minio"
      proxied  = true
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - minio - web panel"
    }, 
    "homelab_k8s_api_a" = { 
      content  = "46.62.184.91"
      name     = "homelab.k8s"
      proxied  = false
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - k8s homelab cluster control plane api endpoint - web panel"
    },
    "argocd_a" = {
      content  = "46.62.184.91"
      name     = "argocd"
      proxied  = false
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - argocd web panel"
    },
    "scs_c03_quiz_a" = {
      content  = "46.62.184.91"
      name     = "scs-c03"
      proxied  = true
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - SCS-C03 quiz"
    },
    "grafana_a" = {
      content  = "46.62.184.91"
      name     = "grafana"
      proxied  = false
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - grafana web panel"
    },
    "alerta_a" = {
      content  = "46.62.184.91"
      name     = "alerta"
      proxied  = false
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - alerta web panel"
    },
    "alertmanager_a" = {
      content  = "46.62.184.91"
      name     = "alertmanager"
      proxied  = false
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - alertmanager web panel (behind Traefik basicAuth)"
    },
    "goalert_a" = {
      content  = "46.62.184.91"
      name     = "goalert"
      proxied  = false
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - goalert web panel"
    },
    "mimir_a" = {
      content  = "46.62.184.91"
      name     = "mimir"
      proxied  = false
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - mimir remote_write/query endpoint (behind Traefik basicAuth)"
    },
    "prometheus_a" = {
      content  = "46.62.184.91"
      name     = "prometheus"
      proxied  = false
      tags     = []
      ttl      = 1
      type     = "A"
      settings = {}
      comment = "terraform managed - prometheus remote_write endpoint only, behind Traefik basicAuth"
    },
  }
}

resource "cloudflare_dns_record" "main" {
  for_each = local.cf_dns_records
  
  content  = each.value.content
  name     = each.value.name
  proxied  = each.value.proxied
  tags     = each.value.tags
  ttl      = each.value.ttl
  type     = each.value.type
  zone_id  = local.cf_zone_id
  settings = each.value.settings
  comment  = each.value.comment
}