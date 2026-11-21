# proxy (10.10.10.2)

The single entry point: Proxmox forwards public ports 80/443 here.

## Traefik (docker compose)

| Repo | Host |
|---|---|
| `traefik/docker-compose.yml` | `/root/traefik/docker-compose.yml` |
| `traefik/dynamic/*.yml` | `/root/traefik/dynamic/` (watched, hot reload) |
| `traefik/.env.example` | `/root/traefik/.env` (ACME email) |
| - | `/root/traefik/auth/*.htpasswd` (basicAuth users, not in git - `kubernetes/SECRETS.md`) |
| - | `/root/traefik/acme.json` (Let's Encrypt certs, not in git) |

One file in `dynamic/` per domain: router(s) + service pointing at a VM
or at Kubernetes NodePorts. Adding a domain = new file there + DNS record in
`terraform/live/cloudflare/zones/swasilewski.pl/zones.tf`.

## Alloy + blackbox probes (systemd)

| Repo | Host |
|---|---|
| `alloy/config.d/config.alloy` | `/etc/alloy/config.d/config.alloy` |
| `alloy/config.d/probes-homelab.alloy` | `/etc/alloy/config.d/probes-homelab.alloy` |
| `alloy/blackbox.yml` | `/etc/alloy/blackbox.yml` |

`probes-homelab.alloy` is the list of monitored endpoints (HTTP/TCP probes);
`blackbox.yml` defines the probe modules (`http_2xx`, `http_s3`,
`http_basicauth`, `tcp_connect`, ...).
