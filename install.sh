#!/bin/bash

###### Honeydeck Sensor Install Script ######

# Check for root before beginning
if [ "$EUID" -ne 0 ]
    then echo "This installer must be run as root."
    exit
fi

LOG_FILE=/var/log/honeydeck/sensor/log.txt
UPDATE_INTERVAL=15 # minutes
UPDATER_PATH="$(dirname $(realpath ${0}))/update.sh"
CURRENT_BRANCH="$(git branch)"

mkdir -p ${LOG_FILE}

echo "###### $(date) Performing Update ######" | tee ${LOG_FILE}
echo "### UPDATE_INTERVAL: ${UPDATE_INTERVAL}" | tee ${LOG_FILE}
echo "### UPDATER_PATH: ${UPDATER_PATH}" | tee ${LOG_FILE}
echo "### CURRENT_BRANCH: ${CURRENT_BRANCH}" | tee ${LOG_FILE}

echo "### Installing Required Packages" | tee ${LOG_FILE}
yum install python3 git -y

echo "### Adding github's ssh fingerprints" | tee ${LOG_FILE}
if ! grep -q "^github.com" ~/.ssh/known_hosts; then
    ssh-keyscan -t rsa github.com tee ~/.ssh/known_hosts
fi

echo "### Fetching latest version" | tee ${LOG_FILE}
git pull

echo "### Installing required pip packages" | tee ${LOG_FILE}
pip3 install -r requirements.txt

echo "### Adding cron updater" | tee ${LOG_FILE}
grep "sh ${UPDATER_PATH}" /etc/crontab || \
    echo "*/${UPDATE_INTERVAL} *  *  *  * sh honeydeck-sensor/update.sh" >> /etc/crontab
