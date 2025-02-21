# Getting Vulhub Working

## Deploy Ludus Range
```
ludus range deploy
```
## Create SSH Keys
Rename this key to ansible
```
ssh-keygen -t ed25519 -C "ansible key"
```

## Move SSH Keys to VMs
```
ssh-copy-id -i ~/.ssh/ansible.pub debian@10.13.99.2
```
## Downloading required roles
```
ludus ansible roles add badsectorlabs.ludus_vulhub
```
```
ansible-galaxy install geerlingguy.docker --roles-path=~/vulhub/roles/
```
## Creating the Ansible Folders and Files
```
mkdir vulhub
```
```
 mkdir defaults handlers meta tasks tests vars files templates roles
```
### Ansible.cfg
Change to your home directories
```
[defaults]
roles_path = /home/brayden-g/vulhub/roles:/home/brayden-g/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
```
### Defaults folder
In the defaults folder create a new file called main.yml
```
nano defaults/main.yml
```
```
---
vulhub_git_url: https://github.com/vulhub/vulhub
vulhub_install_path: /opt/vulhub
vulhub_branch: master
vulhub_envs:
```
### Tasks Folder
Create a new file called main.yml in the Tasks Folder
```
nano tasks/main.yml
```
```
---
- name: Update APT cache
  ansible.builtin.apt:
    update_cache: true
  when: ansible_os_family == "Debian"

- name: Install git if required
  ansible.builtin.package:
    name: git
    state: present

- name: Install CA Certificates (Debian-based systems)
  ansible.builtin.apt:
    name: ca-certificates
    state: present
  when: ansible_os_family == "Debian"

- name: Install required dependencies
  ansible.builtin.package:
    name:
      - wget
      - curl
      - tar
      - ufw
      - python3-passlib
    state: present

- name: Enable UFW (Firewall)
  community.general.ufw:
    state: enabled

- name: Allow SSH through firewall
  community.general.ufw:
    rule: allow
    port: "22"
    proto: tcp

- name: Get the source code
  ansible.builtin.git:
    repo: "{{ vulhub_git_url }}"
    dest: "{{ vulhub_install_path }}"
    version: "{{ vulhub_branch }}"
    single_branch: true

- name: Stop any existing vulhub docker containers
  ansible.builtin.shell: 
```

### Meta Folder
Create main.yml
```
nano meta/main.yml
```
```
  # next line and provide a value
  # issue_tracker_url: http://example.com/issue/tracker

  # Choose a valid license ID from https://spdx.org - some suggested licenses:
  # - BSD-3-Clause (default)
  # - MIT
  # - GPL-2.0-or-later
  # - GPL-3.0-only
  # - Apache-2.0
  # - CC-BY-4.0
  license: license (GPL-2.0-or-later, MIT, etc)

  min_ansible_version: 2.1

  # If this a Container Enabled role, provide the minimum Ansible Container version.
  # min_ansible_container_version:

  #
  # Provide a list of supported platforms, and for each platform a list of versions.
  # If you don't wish to enumerate all versions for a particular platform, use 'all'.
  # To view available platforms and versions (or releases), visit:
  # https://galaxy.ansible.com/api/v1/platforms/
  #
  # platforms:
  # - name: Fedora
  #   versions:
  #   - all
  #   - 25
  # - name: SomePlatform
  #   versions:
  #   - all
  #   - 1.0
  #   - 7
  #   - 99.99

  galaxy_tags: []
    # List tags for your role here, one per line. A tag is a keyword that describes
    # and categorizes the role. Users find roles by searching for tags. Be sure to
    # remove the '[]' above, if you add tags to this list.
    #
    # NOTE: A tag is limited to a single word comprised of alphanumeric characters.
    #       Maximum 20 tags per role.

# NEED TO ADD LATER geerlingguy.docker
dependencies: []
  # List your role dependencies here, one per line. Be sure to remove the '[]' above,
  # if you add dependencies to this list.
  #- role: geerlingguy.docker
  #  version: "7.1.0"
```

### Requirements.yml File
This file is put in the vulhub folder.
```
nano requirements.yml
```
```
---
roles:
  - name: geerlingguy.docker
    src: https://github.com/geerlingguy/ansible-role-docker
    version: master
    path: /home/brayden-g/vulhub/roles/
```

### Inventory.ini File
This file is put in the vulhub folder.
```
nano inventory.ini
```

Add change IP to your VMs IP
```
[vulhub_hosts]
10.13.99.2 ansible_user=debian ansible_ssh_private_key_file=~/.ssh/ansible
```
### Playbook.yml file
Create the playbook.yml file
```
nano playbook.yml
```
Insert code below into the playbook.yml file
```
---
- hosts: vulhub_hosts
  become: true
  roles:
    - badsectorlabs.ludus_vulhub
  vars:
    vulhub_envs:
      - confluence/CVE-2023-22527
      - airflow/CVE-2020-11978
```
# Deploying the script
```
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

# Done
