#!/bin/sh
git pull
cd sensor
ansible-playbook main.yml