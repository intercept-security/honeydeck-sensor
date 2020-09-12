#!/bin/bash

###### Honeydeck Sensor Install Script ######

LOG_DIR=/var/log/honeydeck/sensor
LOG_FILE="${LOG_DIR}/log.txt"
UPDATE_INTERVAL=15 # minutes
UPDATER_PATH="$(dirname $(realpath ${0}))/update.sh"
CURRENT_BRANCH="$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')"

sudo mkdir -p ${LOG_DIR}
sudo touch ${LOG_FIL}}

sudo echo "###### $(date) Performing Install ######" | tee ${LOG_FILE}
sudo echo "### UPDATE_INTERVAL: ${UPDATE_INTERVAL}" | tee ${LOG_FILE}
sudo echo "### UPDATER_PATH: ${UPDATER_PATH}" | tee ${LOG_FILE}
sudo echo "### CURRENT_BRANCH: ${CURRENT_BRANCH}" | tee ${LOG_FILE}

sudo echo "### Installing Required Packages" | tee ${LOG_FILE}
sudo yum install python3 git -y

sudo echo "### Adding github's ssh fingerprints" | tee ${LOG_FILE}
if ! grep -q "^github.com" ~/.ssh/known_hosts; then
    ssh-keyscan -t rsa github.com tee ~/.ssh/known_hosts
fi

sudo echo "### Fetching latest version from ${CURRENT_BRANCH}" | tee ${LOG_FILE}
git pull

sudo echo "### Installing required pip packages" | tee ${LOG_FILE}
pip3 install -r requirements.txt

sudo echo "### Adding cron updater" | tee ${LOG_FILE}
grep "sh ${UPDATER_PATH}" /etc/crontab || \
    sudo echo "*/${UPDATE_INTERVAL} *  *  *  * sh honeydeck-sensor/update.sh" >> /etc/crontab

sudo echo "###### $(date) Completed Install ######" | tee ${LOG_FILE}
