#!/usr/bin/env bash
set -euo pipefail

echo "[worker] starting ansible worker"

WORKSPACE_DIR="${WORKSPACE_DIR:-/workspace}"
ANSIBLE_DIR="${ANSIBLE_DIR:-$WORKSPACE_DIR/ansible}"

PLAYBOOK="${PLAYBOOK:-}"
INVENTORY="${INVENTORY:-}"
LIMIT="${LIMIT:-}"
TAGS="${TAGS:-}"
SKIP_TAGS="${SKIP_TAGS:-}"
EXTRA_ARGS="${EXTRA_ARGS:-}"

if [ -z "$PLAYBOOK" ]; then
  echo "[worker] ERROR: PLAYBOOK is not set"
  exit 1
fi

if [ -z "$INVENTORY" ]; then
  echo "[worker] ERROR: INVENTORY is not set"
  exit 1
fi

if [ ! -d "$ANSIBLE_DIR" ]; then
  echo "[worker] ERROR: ansible dir not found: $ANSIBLE_DIR"
  exit 1
fi

if [ -f "$ANSIBLE_DIR/ansible.cfg" ]; then
  export ANSIBLE_CONFIG="$ANSIBLE_DIR/ansible.cfg"
  echo "[worker] using ansible.cfg: $ANSIBLE_CONFIG"
fi

mkdir -p /root/.ssh
chmod 700 /root/.ssh

if [ -n "${SSH_PRIVATE_KEY:-}" ]; then
  echo "[worker] writing SSH private key"
  printf '%s\n' "$SSH_PRIVATE_KEY" > /root/.ssh/ansible_key
  chmod 600 /root/.ssh/ansible_key
fi

if [ -n "${SSH_KNOWN_HOSTS:-}" ]; then
  echo "[worker] writing known_hosts"
  printf '%s\n' "$SSH_KNOWN_HOSTS" > /root/.ssh/known_hosts
  chmod 644 /root/.ssh/known_hosts
fi

cd "$ANSIBLE_DIR"

CMD=(ansible-playbook "$PLAYBOOK" -i "$INVENTORY")

if [ -n "$LIMIT" ]; then
  CMD+=(--limit "$LIMIT")
fi

if [ -n "$TAGS" ]; then
  CMD+=(--tags "$TAGS")
fi

if [ -n "$SKIP_TAGS" ]; then
  CMD+=(--skip-tags "$SKIP_TAGS")
fi

if [ -n "${VAULT_PASSWORD:-}" ]; then
  echo "[worker] writing vault password file"
  printf '%s\n' "$VAULT_PASSWORD" > /tmp/.vault_pass
  chmod 600 /tmp/.vault_pass
  CMD+=(--vault-password-file /tmp/.vault_pass)
fi

if [ -n "$EXTRA_ARGS" ]; then
  read -ra EXTRA_SPLIT <<< "$EXTRA_ARGS"
  CMD+=("${EXTRA_SPLIT[@]}")
fi

echo "[worker] running: ${CMD[*]}"
exec "${CMD[@]}"