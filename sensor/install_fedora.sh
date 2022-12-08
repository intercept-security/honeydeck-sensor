#!/bin/bash
sudo yum update -y
sudo yum install python3 git -y
pip3 install --user --upgrade pip
pip3 install ansible --user
export PATH="$PATH:$HOME/.local/bin"

ansible-playbook sensor/install_sensor.yml
