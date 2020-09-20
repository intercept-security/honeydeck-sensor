#!/bin/sh

# Ensure we are root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

###### Honeydeck Sensor Install Script ######

LOG_DIR=/var/log/honeydeck/sensor
LOG_FILE="${LOG_DIR}/log.txt"
UPDATE_INTERVAL=15 # minutes
UPDATER_PATH="$(dirname $(realpath ${0}))/update.sh"

mkdir -p ${LOG_DIR}
touch ${LOG_FILE}

echo "###### $(date) Performing Install ######" | tee -a ${LOG_FILE}

echo "### Installing Required Packages" | tee -a ${LOG_FILE}
apt-get update && apt-get install software-properties-common python3-pip git cron -y
systemctl enable cron

CURRENT_BRANCH="$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')"
echo "### UPDATE_INTERVAL: ${UPDATE_INTERVAL}" | tee -a ${LOG_FILE}
echo "### UPDATER_PATH: ${UPDATER_PATH}" | tee -a ${LOG_FILE}
echo "### CURRENT_BRANCH: ${CURRENT_BRANCH}" | tee -a ${LOG_FILE}



echo "### Adding github's ssh fingerprints" | tee -a ${LOG_FILE}
if ! grep -q "^github.com" ~/.ssh/known_hosts; then
    ssh-keyscan -t rsa github.com tee -a ~/.ssh/known_hosts
fi

echo "### Fetching latest version from ${CURRENT_BRANCH}" | tee -a ${LOG_FILE}
git pull

echo "### Installing required pip packages" | tee -a ${LOG_FILE}
pip3 install -r requirements.txt

echo "### Adding cron updater" | tee -a ${LOG_FILE}
grep "sh ${UPDATER_PATH}" /etc/crontab || \
    echo "*/${UPDATE_INTERVAL} *  *  *  * sh /code/sensor/update.sh >> ${LOG_FILE}" | tee -a /etc/crontab

echo "###### $(date) Completed Install ######" | tee -a ${LOG_FILE}
