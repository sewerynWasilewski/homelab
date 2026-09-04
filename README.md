# Homelab

Infrastructure-as-code for my homelab: Proxmox VMs, a kubeadm k8s cluster,
Docker services, and a Prometheus/Mimir/Grafana monitoring stack.

- `ansible/` — VM provisioning and k8s bootstrap
- `docker/` — Traefik, Postgres, MinIO, and other VM-hosted services
- `kubernetes/` — Helm charts (monitoring stack, website)
- `terraform/` — Proxmox VMs and Cloudflare DNS

## Keys & secrets

- `keys/` — SSH keys, gitignored (only `.gitkeep` is tracked)
- `secret-*.yaml` and `values.secrets.yaml` — real credentials, gitignored;
  each has a committed `.example` sibling showing what to fill in
