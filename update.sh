#!/bin/sh

###### Honeydeck Sensor Install Script ######

CURRENT_BRANCH="$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')"
LOG_DIR=/var/log/honeydeck/sensor
LOG_FILE="${LOG_DIR}/log.txt"

sudo mkdir -p ${LOG_DIR}
sudo touch ${LOG_FILE}

sudo echo "###### $(date) Performing Update ######" | sudo tee -a ${LOG_FILE}
sudo echo "### CURRENT_BRANCH: ${CURRENT_BRANCH}" | sudo tee -a ${LOG_FILE}


sudo echo "### Fetching latest version from ${CURRENT_BRANCH}" | sudo tee -a ${LOG_FILE}
git reset --hard
git pull

sudo echo "### Deploying updater playbook" | sudo tee -a ${LOG_FILE}
cd sensor
ansible-playbook main.yml

sudo echo "###### $(date) Completed Update ######" | sudo tee -a ${LOG_FILE}
