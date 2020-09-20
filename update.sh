#!/bin/sh

# Ensure we are root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

###### Honeydeck Sensor Install Script ######

CURRENT_BRANCH="$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')"
LOG_DIR=/var/log/honeydeck/sensor
LOG_FILE="${LOG_DIR}/log.txt"

mkdir -p ${LOG_DIR}
touch ${LOG_FILE}

echo "###### $(date) Performing Update ######" | tee -a ${LOG_FILE}
echo "### CURRENT_BRANCH: ${CURRENT_BRANCH}" | tee -a ${LOG_FILE}


echo "### Fetching latest version from ${CURRENT_BRANCH}" | tee -a ${LOG_FILE}
git reset --hard
git pull

echo "### Deploying updater playbook" | tee -a ${LOG_FILE}
cd sensor
ansible-playbook main.yml

echo "###### $(date) Completed Update ######" | tee -a ${LOG_FILE}
