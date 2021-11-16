#!/bin/sh

###### Honeydeck Sensor Install Script ######

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
LOG_DIR=/var/log/honeydeck/sensor
LOG_FILE="${LOG_DIR}/log.txt"
UPDATE_CRON="*/15 *  *  *  *"  # Every 15 minutes by default
UPDATER_PATH="$(dirname $(realpath ${0}))/update.sh"
CURRENT_BRANCH="$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')"

sudo mkdir -p ${LOG_DIR}
sudo touch ${LOG_FILE}

sudo echo "###### $(date) Performing Install ######" | sudo tee -a ${LOG_FILE}
sudo echo "### UPDATE_INTERVAL: ${UPDATE_CRON}" | sudo tee -a ${LOG_FILE}
sudo echo "### UPDATER_PATH: ${UPDATER_PATH}" | sudo tee -a ${LOG_FILE}
sudo echo "### CURRENT_BRANCH: ${CURRENT_BRANCH}" | sudo tee -a ${LOG_FILE}

sudo echo "### Installing Required Packages" | sudo tee -a ${LOG_FILE}
sudo yum install python3 git -y

sudo echo "### Adding github's ssh fingerprints" | sudo tee -a ${LOG_FILE}
mkdir ~/.ssh
if ! grep -q "^github.com" ~/.ssh/known_hosts; then
    ssh-keyscan -t rsa github.com | tee -a ~/.ssh/known_hosts
fi

sudo echo "### Fetching latest version from ${CURRENT_BRANCH}" | sudo tee -a ${LOG_FILE}
git pull

sudo echo "### Installing required pip packages" | sudo tee -a ${LOG_FILE}
pip3 install --user wheel
pip3 install --user -r requirements.txt

sudo echo "### Adding cron updater" | sudo tee -a ${LOG_FILE}
sudo crontab -l > .tmp_honeydeck_install_cron
grep "${UPDATER_PATH}" .tmp_honeydeck_install_cron

if [ $? -gt 0 ]
then
    echo "${UPDATE_CRON} cd ${SCRIPT_DIR} && sh ${UPDATER_PATH}" | tee -a .tmp_honeydeck_install_cron
    crontab .tmp_honeydeck_install_cron
fi
rm .tmp_honeydeck_install_cron

sudo echo "###### $(date) Completed Install ######" | sudo tee -a ${LOG_FILE}
