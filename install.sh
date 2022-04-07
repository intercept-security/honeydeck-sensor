#!/bin/sh
sudo yum update -y
sudo yum install python3 git -y
pip3 install ansible --user

ansible-playbook sensor/install_sensor.yml

