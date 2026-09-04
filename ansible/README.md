curl -O https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml


## ansible user

### create user on already running machine 

```sh
sudo adduser --disabled-password --gecos "" ansible
sudo usermod -aG sudo ansible
sudo mkdir -p /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh
echo "<ANSIBLE_PUBLIC_KEY>" | sudo tee /home/ansible/.ssh/authorized_keys
sudo chmod 600 /home/ansible/.ssh/authorized_keys
sudo chown -R ansible:ansible /home/ansible/.ssh
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible
```

### cloud-init


```yml
users: 
  - name: ansible
    gecos: Ansible User
    shell: /bin/bash
    groups: [sudo]
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: false
    passwd: ${ansible_password_hash}
    ssh_authorized_keys:
      - ${ansible_ssh_public_key}
```