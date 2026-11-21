# Argo CD

GitOps for the homelab cluster: every chart in `kubernetes/helm_charts/` is
deployed by Argo CD from the `main` branch of this repo. **Push to `main` =
deploy** (Argo polls git every ~3 min). Manual `helm upgrade` is no longer
used - changes made by hand in the cluster are reverted (`selfHeal`).

- UI: https://argocd.swasilewski.pl (Traefik -> NodePort 30180), user `admin`
- `root.yaml` - app-of-apps, watches `apps/`
- `apps/<name>.yaml` - one Application per chart. Application name = Helm
  release name, so resource names stay the same.

Credentials are **not** managed by Argo CD - see `../SECRETS.md`.

## Install / upgrade Argo CD itself

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argocd argo/argo-cd --version 10.18.2 \
  -n argocd --create-namespace -f kubernetes/argocd/values.yaml
kubectl apply -f kubernetes/argocd/root.yaml   # once
```

Initial admin password (change it in the UI, then delete the secret):

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d; echo
```

## Adding a new app

1. Add the chart under `kubernetes/helm_charts/`.
2. Create its secrets by hand (`../SECRETS.md`).
3. Copy one of `apps/*.yaml`, change `name`, `path`, `releaseName`, namespace.
4. Push to `main`.

## Deploying a new website image

Build the image (website repo -> GitHub Actions "Build and Push Image" with a
tag), then bump `image.tag` in `kubernetes/helm_charts/website/values.yaml`
and push.
