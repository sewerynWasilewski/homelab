```
docker build -t ansible-worker:dev ./ansible-worker 
```
```
docker run --rm \
  -v "$(pwd):/workspace" \
  -e PLAYBOOK=playbooks/09-init-k8s-cluster.yml \
  -e INVENTORY=inventory/homelab/hosts.yml \
  -e LIMIT=k8s -e SSH_PRIVATE_KEY="$(cat ./ansible_key)" \
  ansible-worker:v1.0
```

```
  docker run --rm \
    -v "$(pwd):/workspace" \
    -e PLAYBOOK=playbooks/03-join-workers.yml \
    -e INVENTORY=inventory/homelab/hosts.yaml \
    -e LIMIT=k8s-worker-03 \
    -e SSH_PRIVATE_KEY="$(cat ./ansible_key)" \
    ansible-worker:v1.0
```

claude --resume 4290f82a-0cef-4e4f-8c86-36324f6d160e