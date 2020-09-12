#!/bin/bash

# Check for root before beginning
if [ "$EUID" -ne 0 ]
    then echo "This installer must be run as root."
    exit
fi

LOG_DIR=/var/log/honeydeck/sensor
UPDATE_INTERVAL=15 # minutes
UPDATER_PATH="$(dirname $(realpath ${0}))/update.sh"
CURRENT_BRANCH="$(git branch)"

mkdir -p ${LOG_DIR}

echo "### $(date) Performing Update ###" | tee ${LOG_DIR}
echo "UPDATE_INTERVAL: ${UPDATE_INTERVAL}" | tee ${LOG_DIR}
echo "UPDATER_PATH: ${UPDATER_PATH}" | tee ${LOG_DIR}
echo "CURRENT_BRANCH: ${CURRENT_BRANCH}" | tee ${LOG_DIR}

echo "Installing Required Packages" | tee ${LOG_DIR}
yum install python3 git -y

echo "Adding github's ssh fingerprints" | tee ${LOG_DIR}
if ! grep -q "^github.com" ~/.ssh/known_hosts; then
    ssh-keyscan -t rsa github.com tee ~/.ssh/known_hosts
fi

echo "Fetching latest version" | tee ${LOG_DIR}
git pull

echo "Installing required pip packages" | tee ${LOG_DIR}
pip3 install -r requirements.txt

echo "Adding cron updater" | tee ${LOG_DIR}
grep "sh ${UPDATER_PATH}" /etc/crontab || \
    echo "*/${UPDATE_INTERVAL} *  *  *  * sh honeydeck-sensor/update.sh" tee /etc/crontab
