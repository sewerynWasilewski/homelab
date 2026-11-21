# Secrets

This repo is **public**. No credential is ever committed — not in values files,
not in manifests, not as a hash.

## How it works

- All real values live in the repo-root **`.env`** (gitignored). `.env.example`
  lists every key with no values.
- Helm charts never contain credentials. They only reference a Kubernetes
  Secret **by name** (`existingSecret: ...`), so ArgoCD can sync the charts
  straight from git.
- Secrets are created in the cluster **once, by hand**, from `.env`, and
  survive chart upgrades/syncs (ArgoCD does not manage them).

## Creating / updating a secret

Load `.env` into the shell, then create the Secret with `kubectl`
(`--dry-run=client -o yaml | kubectl apply -f -` makes it work for both
create and update):

```bash
set -a; source .env; set +a

kubectl -n monitoring create secret generic grafana-admin-credentials \
  --from-literal=GF_SECURITY_ADMIN_USER="$K8S_GRAFANA_ADMIN_USER" \
  --from-literal=GF_SECURITY_ADMIN_PASSWORD="$K8S_GRAFANA_ADMIN_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -
```

Pods read secrets only on start, so after changing one restart its workload:
`kubectl -n monitoring rollout restart deploy/<name>`.

## Adding a new secret

1. Add `K8S_<APP>_<WHAT>=` to `.env.example` (empty) and the real value to `.env`.
2. Add a row to the table below.
3. Create it in the cluster with the command above.
4. In the chart, reference it by name only (`existingSecret` in `values.yaml`,
   then `secretKeyRef` / `envFrom` / a secret volume in the template).

## Existing secrets

All in namespace `monitoring` unless noted.

| Secret | Key ← `.env` variable | What it is |
|---|---|---|
| `alerta-database` | `DATABASE_URL` ← `K8S_ALERTA_DATABASE_URL` | Postgres connection string for Alerta (`postgres://user:pass@host:5432/db`) |
| `alertmanager-alerta-key` | `alerta-api-key` ← `K8S_ALERTMANAGER_ALERTA_API_KEY` | Alerta API key (scopes `write:webhooks write:alerts`) Alertmanager uses to push alerts. Create with `alertad key` in the alerta pod |
| `alertmanager-goalert-webhook` | `url` ← `K8S_ALERTMANAGER_GOALERT_WEBHOOK_URL` | GoAlert integration URL, includes the token (GoAlert → service → Integration Keys) |
| `goalert-database` | `DATABASE_URL` ← `K8S_GOALERT_DATABASE_URL` | Postgres connection string for GoAlert |
| `goalert-encryption-key` | `DATA_ENCRYPTION_KEY` ← `K8S_GOALERT_DATA_ENCRYPTION_KEY` | Key GoAlert encrypts data in its DB with. **Losing it = losing that data**, never rotate casually |
| `alloy-mimir-credentials` | `MIMIR_PASSWORD` ← `K8S_ALLOY_MIMIR_PASSWORD` | Basic-auth password in-cluster Alloy uses to push metrics to `mimir.swasilewski.pl` (tenant `homelab`) |
| `grafana-admin-credentials` | `GF_SECURITY_ADMIN_USER`, `GF_SECURITY_ADMIN_PASSWORD` ← `K8S_GRAFANA_ADMIN_USER`, `K8S_GRAFANA_ADMIN_PASSWORD` | Grafana admin login. Only applied on first start — to rotate, also run `grafana-cli admin reset-admin-password` in the pod |
| `mimir-minio-credentials` | `MINIO_ACCESS_KEY_ID`, `MINIO_SECRET_ACCESS_KEY` ← `K8S_MIMIR_MINIO_*` | MinIO (S3) access key for Mimir's block storage on `10.10.10.10` |
| `oncall-postgresql` | `password` ← `K8S_ONCALL_POSTGRESQL_PASSWORD` | Grafana OnCall DB password (`oncall_user`). OnCall not deployed yet |
| `oncall-rabbitmq` | `username`, `password` ← `K8S_ONCALL_RABBITMQ_*` | Grafana OnCall RabbitMQ broker login. OnCall not deployed yet |
| `registry-credentials` (ns `website`) | docker config ← `K8S_REGISTRY_SERVER`, `K8S_REGISTRY_USERNAME`, `K8S_REGISTRY_PASSWORD` | Image pull secret for `registry.swasilewski.pl` |

The pull secret is a different type:

```bash
kubectl -n website create secret docker-registry registry-credentials \
  --docker-server="$K8S_REGISTRY_SERVER" \
  --docker-username="$K8S_REGISTRY_USERNAME" \
  --docker-password="$K8S_REGISTRY_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -
```

## Traefik basicAuth (proxy VM)

Alertmanager UI and the Mimir endpoint are protected
by Traefik basicAuth. The users files exist **only on the proxy VM** in
`/root/traefik/auth/` (mounted as `/auth`, gitignored as `hosts/proxy/traefik/auth/`);
the dynamic configs reference them via `usersFile`.

| File | User | `.env` variable | Used by |
|---|---|---|---|
| `alertmanager.htpasswd` | `admin` | `TRAEFIK_ALERTMANAGER_ADMIN_PASSWORD` | you, in the browser |
| `mimir.htpasswd` | `homelab` (= tenant) | `TRAEFIK_MIMIR_HOMELAB_PASSWORD` | Alloy on the hosts (`MIMIR_PASSWORD` in `/etc/default/alloy`) and in-cluster (`alloy-mimir-credentials`, same value) |

Rotate a password: put the new value in `.env`, then

```bash
docker run --rm httpd:2.4-alpine htpasswd -nbB -C 12 homelab "$TRAEFIK_MIMIR_HOMELAB_PASSWORD" \
  | ssh -J root@46.62.184.91 root@10.10.10.2 'cat > /root/traefik/auth/mimir.htpasswd'
```

Traefik picks it up without a restart. Then update every client listed above
(`/etc/default/alloy` + `systemctl restart alloy`, the k8s Secret + restart the
alloy DaemonSet).

## Other secrets in the repo (not Kubernetes)

- `.env` (root): also Proxmox API token (`PM_API_TOKEN_*`), Cloudflare
  (`CLOUDFLARE_*`), Terraform state backend (`PG_CONN_STR`).
- `terraform/live/**/terraform.tfvars`: gitignored, `.tmpl` sibling is committed.
- `hosts/**/.env`: per compose stack, gitignored, `.env.example` is committed.
- `keys/`: SSH keys, gitignored.

## If something leaks

Assume it is public the moment it is pushed. **Rotate it first** (new
password/key, update `.env`, re-create the Secret, restart the pod), then
clean git history if you want — rewriting history does not un-leak a value.
