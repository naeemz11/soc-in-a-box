# Setting Up ansible

## Connect to server
1. Turn on Wireguard VPN
2. Connection to SSH via CMD or your choice

# Start Range
```
ludus range deploy
```
As range starts create keys

## Create SSH for Ansible account
```
ssh-keygen -t ed25519 -C "ansible key"
```
Does not need a password when creating it

## Copy Key to Servers
```
ssh-copy-id -i ~/.ssh/id_ed25519.pub debian@10.13.99.2
ssh-copy-id -i ~/.ssh/id_ed25519.pub kali@10.13.99.1
```

## Create an inventroy file
```
[servers]
10.13.99.1 ansible_user=kali ansible_ssh_private_key_file=/home/{REPLACE}/.ssh/ansible
10.13.99.2 ansible_user=debian ansible_ssh_private_key_file=/home/{REPLACE}/.ssh/ansible
```

## Create Test Playbook
```
---

- hosts: all
  become: true
  tasks:

  - name: install apache2
    apt:
      name: apache2
```
