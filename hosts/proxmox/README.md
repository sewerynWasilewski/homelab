# proxmox (46.62.184.91)

Bare-metal Proxmox VE host. All VMs sit on the internal bridge `vmbr1`
(10.10.10.0/24); `vmbr0` holds the public IP.

## Networking (iptables NAT)

- `PREROUTING -i vmbr0 --dport 80,443 -> 10.10.10.2` (Traefik on the proxy VM)
- `PREROUTING -i vmbr0 --dport 6443 -> 10.10.10.81` (Kubernetes API)
- `POSTROUTING -s 10.10.10.0/24 -o vmbr0 MASQUERADE` (internet for VMs)

DNAT only matches traffic arriving on `vmbr0`, so VMs calling the public IP
directly hit Proxmox itself (no NAT hairpin) - see `issues.md`.

## Alloy (systemd)

| Repo | Host |
|---|---|
| `alloy/config.alloy` | `/etc/alloy/config.alloy` |
| - | `/etc/default/alloy` (`MIMIR_PASSWORD`, not in git) |

Host metrics (node exporter), prometheus-pve-exporter, pushed to Mimir.
