#!/bin/sh
sudo yum install python3 -y
mkdir .venvs
python3 -m venv .venvs/honeydeck_sensor
sudo pip install requirements.txt