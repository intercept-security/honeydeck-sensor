#!/bin/bash
export PATH="$PATH:$HOME/.local/bin"

ansible-galaxy collection install community.general
ansible-playbook sensor/update.yml
