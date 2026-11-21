# Hosts

Everything that runs **outside Kubernetes**, grouped by the machine it runs on.
Each directory mirrors what is deployed on that host. Changes are copied to the
host by hand (`scp` + restart) - there is no automation for these yet.

| Host | IP | What runs there | How |
|---|---|---|---|
| [`proxmox/`](proxmox/) | 46.62.184.91 (public) | Proxmox VE hypervisor, NAT for the VMs, Alloy | systemd |
| [`proxy/`](proxy/) | 10.10.10.2 | Traefik (single entry point for all domains), Alloy + blackbox probes | docker compose, systemd |
| [`services/`](services/) | 10.10.10.10 | MinIO, PostgreSQL, RabbitMQ, container registry, scs-c03-quiz, Alloy | docker compose, systemd |
| [`wordpress/`](wordpress/) | 10.10.10.12 | WordPress (alkaliastudio.pl) + MariaDB | docker compose |

Kubernetes (`k8s-cp-01`, `k8s-worker-0[1-3]`, 10.10.10.81-84) is managed by
Argo CD from `kubernetes/` - see `kubernetes/argocd/README.md`.

## Conventions

- **docker compose stacks** live on the host in `/root/<directory-name>/`
  (e.g. `hosts/services/postgresql/` -> `/root/postgresql/`). Deploy:
  `scp` the files, then `docker compose up -d` in that directory.
- **Alloy** (metrics agent) is **not** a container - it is the `alloy` systemd
  service on every host. Config in `/etc/alloy/`, environment (incl.
  `MIMIR_PASSWORD`) in `/etc/default/alloy`. Deploy: copy the config,
  `systemctl restart alloy`.
- Secrets: `.env` next to a compose file (gitignored, `.env.example` is
  committed); Alloy passwords only in `/etc/default/alloy` on the host. See
  `kubernetes/SECRETS.md`.
- Reach hosts through the jump host: `ssh -J root@46.62.184.91 root@10.10.10.x`.
