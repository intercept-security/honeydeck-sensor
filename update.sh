#!/bin/sh

###### Honeydeck Sensor Update Script ######

CURRENT_BRANCH="$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')"
LOG_DIR=/var/log/honeydeck/sensor
LOG_FILE="${LOG_DIR}/log.txt"
export PATH=$PATH:$HOME/.local/bin

sudo mkdir -p ${LOG_DIR}
sudo touch ${LOG_FILE}

sudo echo "###### $(date) Performing Sensor Update ######" | sudo tee -a ${LOG_FILE}

sudo echo "###### $(date) Performing Update ######" | sudo tee -a ${LOG_FILE}
sudo echo "### CURRENT_BRANCH: ${CURRENT_BRANCH}" | sudo tee -a ${LOG_FILE}


sudo echo "### Fetching latest version from ${CURRENT_BRANCH}" | sudo tee -a ${LOG_FILE}
git reset --hard
git pull

pip3 install --user -r requirements.txt

sudo echo "### Deploying updater playbook" | sudo tee -a ${LOG_FILE}
ansible-galaxy collection install community.general
ansible-playbook sensor/update.yml

sudo echo "###### $(date) Completed Sensor Update ######" | sudo tee -a ${LOG_FILE}
