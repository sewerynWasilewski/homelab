# Grafana OnCall

Unlike every other chart under `kubernetes/helm_charts/monitoring/`, this directory intentionally contains **no hand-rolled templates**. Grafana OnCall is deployed via the official upstream Helm chart instead.

## Why not hand-rolled, like the rest of this repo

OnCall isn't a single-container app like Prometheus/Alertmanager/Grafana/kube-state-metrics — it's a full distributed application: a Django API engine, Celery workers + beat for escalation-timer background jobs, PostgreSQL, Redis, RabbitMQ, and a Grafana app plugin (its actual UI) that pairs with the engine through Grafana's own UI. Reinventing that as bespoke manifests would be disproportionate to what it's worth here; using the real chart is the pragmatic choice, same reasoning as running the real kube-state-metrics binary rather than reimplementing it.

## Architecture decisions made

- **Postgres**: external, reusing the existing instance on the `services` VM (`10.10.10.10`) that also holds Terraform state - see `docker/services/postgresql/`. A dedicated `oncall`/`oncall_user` database/role was added, scoped to the k8s subnet in `pg_hba.conf`, separate from the existing `tfstate` role.
- **RabbitMQ**: external, a new container on the same `services` VM - see `docker/services/rabbitmq/`. Chosen over the bundled subchart because it holds actual in-flight escalation/notification state, not just cache (see conversation history / project memory for the full reasoning on why this differs from Redis).
- **Redis**: bundled in-cluster subchart (`redis.enabled: true`, the chart default). Left in Kubernetes because it's pure cache + Celery result backend here - the broker is RabbitMQ, not Redis - so there's no real consequence if it's lost.
- **Ingress**: none. `ingress`, `ingress-nginx`, and `cert-manager` are all disabled - this chart's defaults would otherwise install a full ingress-nginx controller and cert-manager. Instead, TLS and hostname routing happen entirely on the existing external Traefik VM (`10.10.10.2`), the same way `argocd.swasilewski.pl` and the portfolio site are already routed to k8s NodePorts (see `/root/traefik/dynamic/argocd.yml` on that host for the pattern). The engine is exposed as a NodePort (`30160`) for Traefik to point at.
- **Grafana**: `grafana.enabled: false` - reuses the existing release from `../grafana/` instead of a second bundled instance, via `externalGrafana.url`. **Follow-up required**: the chart's automatic `grafana-oncall-app` plugin installation + provisioning only applies to its own bundled Grafana subchart. Since we're pointing at an external one, the plugin needs to be installed into `../grafana/` manually (e.g. `GF_PLUGINS_PREINSTALL`/`GF_INSTALL_PLUGINS` env var) and paired with the engine separately.
- **Slack/Telegram/SMTP**: all disabled for now. No Slack App (OAuth Client ID/Secret/Signing Secret) has been created yet - that's a manual step in Slack's developer console, not something any chart or values file can provide.
- **App secrets** (`oncall.secrets.secretKey`, `mirageSecretKey`): deliberately left unset in `values.yaml` - the chart auto-generates them (`randAlphaNum 40`) if absent.

## Before installing

1. Fill in the real passwords in `secret-postgresql.yaml` and `secret-rabbitmq.yaml` (currently placeholders - **never commit real values**, same discipline as the rest of this repo's secret handling).
2. Confirm Postgres is actually reachable on `10.10.10.10:5432` from the cluster (port rebind + `pg_hba.conf` update applied and the container restarted) and RabbitMQ is running on `10.10.10.10:5672`.
3. Apply the secrets, then install:

```bash
kubectl apply -f secret-postgresql.yaml -f secret-rabbitmq.yaml

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install oncall grafana/oncall \
  --version 1.16.5 \
  --namespace monitoring \
  -f values.yaml
```

## Future decision: phone-call escalation via the existing `callert` system

Tenesys already has a working phone-call notification system (`callert`: Alerta → Asterisk PBX (AMI) → SIP trunk to Orange → real call, with AWS Polly for TTS and Asynq/Redis for retry scheduling - see `~/dev/tenesys/callert`). Orange is a SIP trunk configured inside Asterisk, not a REST API - there's nothing to "integrate with Orange" directly.

Two options when this becomes relevant, not decided yet:
- **A (low effort)**: leave `callert` untouched, reading from Alerta as it does today. Have OnCall's alerts also land in Alerta (fan-out from Alertmanager, or an OnCall→Alerta forward) so calls keep happening exactly as now, with OnCall adding schedules/escalation-chains/Slack/dashboard on top.
- **B (more invasive)**: modify `callert`'s Go source to add a new input package querying OnCall's API directly, so it calls whoever OnCall's *schedule* says is on duty, rather than `callert`'s own `peers`/`intra` config.

Open question for whichever option is chosen: does `callert`'s existing `intra`/`peers` config already track on-call roster independently of what OnCall will manage? If so, Option A risks two separate on-call rosters drifting out of sync.

## Still to do after a healthy install

- Install + provision the `grafana-oncall-app` plugin in the existing Grafana release.
- Add an `oncall.yml` to `/root/traefik/dynamic/` on the Traefik VM (copy `argocd.yml`'s shape), pointing `oncall.swasilewski.pl` at the k8s worker node IPs on port `30160`.
- Add the `oncall.swasilewski.pl` DNS record (check `terraform/live/cloudflare/` - that's likely where the rest of this domain's DNS is managed).
- Create a real Slack App if interactive Acknowledge/Resolve buttons are wanted, once the public URL above is live.

See `docs/grafana_monitoring_stack.md` for how this fits into the rest of the monitoring stack.
