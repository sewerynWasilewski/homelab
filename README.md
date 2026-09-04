TO DO: 

- VPN setup 
- gitlab pipelines CI/CD
- k8s monitoring stack

## Keys

SSH keys and other credentials are stored locally in the `keys/` directory. This directory is **not committed** to the repository — only the empty placeholder (`keys/.gitkeep`) is tracked. Place keys here for local use:

```
keys/
  ansible_key       # SSH private key for Ansible
  ansible_key.pub   # corresponding public key
```