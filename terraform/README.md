# Terraform 

Directory responsible for managing resources by terraform: 

- [proxmox](./proxmox/) - manages proxmox resources
- [cloudflare](./cloudflare/) - manages cloudflare resources

## Terraform State

Terraform state files are stored on postgress database. 

Remmeber to corectly set `PG_CONN_STR` for connection to postgres database.

Database is hosted on container on vm as below. Port Forwarding is used for connection to database. Database is not publicly accessible. 

Start Port Forwarding: 

```
ssh -N  -L 5432:127.0.0.1:5432 -J root@46.62.184.91 ubuntu@10.10.10.10
```

Setup terraform: 
```
export PG_CONN_STR="postgres://<user>:<passwd>@<addres>:<port>/tfstate?sslmode=disable"
terraform init -reconfigure
```