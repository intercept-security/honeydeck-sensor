#!/bin/sh

###### Honeydeck Sensor Install Script ######

CURRENT_BRANCH="$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')"
LOG_DIR=/var/log/honeydeck/sensor
LOG_FILE="${LOG_DIR}/log.txt"

sudo mkdir -p ${LOG_FILE}
sudo touch ${LOG_FILE}

sudo echo "###### $(date) Performing Update ######" | tee ${LOG_FILE}
sudo echo "### CURRENT_BRANCH: ${CURRENT_BRANCH}" | tee ${LOG_FILE}


sudo echo "### Fetching latest version from ${CURRENT_BRANCH}" | tee ${LOG_FILE}
git pull

sudo echo "### Deploying updater playbook" | tee ${LOG_FILE}
cd sensor
ansible-playbook main.yml

sudo echo "###### $(date) Completed Update ######" | tee ${LOG_FILE}
