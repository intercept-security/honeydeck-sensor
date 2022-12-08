#!/bin/bash
sudo apt-get update
sudo apt-get install python3 git python3-pip -y
sudo apt install python3.10-venv -y

pip3 install --user --upgrade pip
pip3 install ansible --user
sudo apt-get -v &> /dev/null
export PATH="$PATH:$HOME/.local/bin"

ansible-playbook sensor/install_sensor.yml
