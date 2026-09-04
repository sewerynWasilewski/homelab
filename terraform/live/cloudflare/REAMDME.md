# CLOUDFLARE

## Learning 

## use of cf-terraforming

```
cf-terraforming generate \
  --zone "$CLOUDFLARE_ZONE_ID" \
  --resource-type "cloudflare_dns_record" \
  --terraform-binary-path "$(which terraform)" \
  > generated.tf

cf-terraforming import \
  --zone "$CLOUDFLARE_ZONE_ID" \
  --resource-type "cloudflare_dns_record" \
  --terraform-binary-path "$(which terraform)"
```