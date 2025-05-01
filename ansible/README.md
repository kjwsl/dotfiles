# Ansible Dotfiles Management

This directory contains Ansible playbooks for managing your dotfiles.

## Prerequisites

1. Install Ansible:
   ```bash
   pip install ansible
   ```

2. Install required collections:
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

## Usage

1. Run the playbook:
   ```bash
   ansible-playbook -i inventory.yml playbook.yml
   ```

## Structure

- `inventory.yml`: Defines the target hosts (localhost)
- `playbook.yml`: Main playbook for managing dotfiles
- `requirements.yml`: Required Ansible collections

## What the Playbook Does

The playbook creates symbolic links for your dotfiles, ensuring they are properly linked from your home directory to the dotfiles repository. 