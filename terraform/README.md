# Terraform 

Directory responsible for managing resources by terraform: 

- [proxmox](./live/proxmox/) - manages proxmox resources (k8s VMs, wordpress VM, cloud images)
- [cloudflare](./live/cloudflare/) - manages cloudflare resources (DNS zone `swasilewski.pl`)

## Terraform State

State is stored in **MinIO (S3)** on the services VM - bucket `tfstate`,
endpoint `https://s3.swasilewski.pl`, one key per directory
(`<provider>/<dir>.tfstate`). The bucket is versioned, so every previous
state can be restored.

**Why MinIO and not Postgres:** ease of use. The S3 endpoint is reachable
over HTTPS from anywhere, so `terraform plan/apply` works without an SSH
tunnel. Locking is kept: `use_lockfile = true` (Terraform >= 1.10) writes a
`.tflock` object with an S3 conditional write - a second concurrent `apply`
fails with `Error acquiring the state lock` (tested), no DynamoDB needed.

### Setup (once per machine)

Credentials for MinIO user `tfstate` (policy `tfstate-policy`, access to this
bucket only) are in the root `.env` (`TF_STATE_*`). The backends use the AWS
profile `homelab-tfstate`, so add it to `~/.aws/credentials`:

```ini
[homelab-tfstate]
aws_access_key_id = tfstate
aws_secret_access_key = <TF_STATE_SECRET_ACCESS_KEY from .env>
```

Then just `terraform init` / `plan` / `apply` in a `live/...` directory.

### Gotchas

- `s3.swasilewski.pl` must stay **not proxied** by Cloudflare. Cloudflare
  rewrites the `Accept-Encoding` header, which the AWS SDK used by Terraform
  signs, so every request fails with `SignatureDoesNotMatch`.
- `workspace_key_prefix = "workspaces"` avoids the default `env:` prefix.
- New directory: copy the `backend "s3"` block from an existing `main.tf` and
  change only `key`. **Never reuse a key** - two directories sharing one state
  will try to delete each other's resources.

### History

Until 2026-11-21 state was in PostgreSQL (backend `pg`, via SSH tunnel). The
old schemas are still in the `tfstate` database on the services VM as a
backup and can be dropped once the MinIO setup has proven itself.
