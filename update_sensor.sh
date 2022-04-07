#!/bin/sh
ansible-galaxy collection install community.general
ansible-playbook sensor/update.yml
