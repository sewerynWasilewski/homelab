# Homelab

Infrastructure-as-code for my homelab: Proxmox VMs, a kubeadm k8s cluster,
Docker services, and a Mimir/Grafana monitoring stack, deployed by Argo CD.

- `ansible/` — VM provisioning and k8s bootstrap
- `hosts/` — everything outside k8s, per machine (Traefik, Postgres, MinIO, Alloy, ...); see `hosts/README.md`
- `kubernetes/` — Helm charts (monitoring stack, website) + Argo CD apps
- `terraform/` — Proxmox VMs and Cloudflare DNS

## Keys & secrets

- `keys/` — SSH keys, gitignored (only `.gitkeep` is tracked)
- `.env` — all real credentials (incl. Kubernetes secrets), gitignored;
  `.env.example` lists the keys. See `kubernetes/SECRETS.md`
