# services (10.10.10.10)

Stateful services shared by the rest of the homelab. Each directory is a
docker compose stack deployed to `/root/<directory>/`.

| Directory | What | Used by |
|---|---|---|
| `minio-server/` | MinIO (S3): API `s3.swasilewski.pl`, console `minio.swasilewski.pl` | Mimir block storage |
| `postgresql/` | PostgreSQL 16 | Terraform state, Alerta, GoAlert, (Grafana OnCall) |
| `rabbitmq/` | RabbitMQ | (Grafana OnCall broker) |
| `container-registry/` | Docker registry + UI: `registry(-ui).swasilewski.pl` | images for k8s and this host |
| `scs-c03-quiz/` | Static quiz page (nginx): `scs-c03.swasilewski.pl` | - |

Runtime data (`data/`, `auth/`) and `.env` files stay on the host only.

## Alloy (systemd)

| Repo | Host |
|---|---|
| `alloy/config.alloy` | `/etc/alloy/config.alloy` |
| - | `/etc/default/alloy` (`MIMIR_PASSWORD`, `MINIO_METRICS_TOKEN`, not in git) |

Host metrics, PostgreSQL and MinIO metrics, pushed to Mimir.
