#!/bin/bash
export PATH="$PATH:$HOME/.local/bin"

ansible-playbook sensor/register_sensor.yml
