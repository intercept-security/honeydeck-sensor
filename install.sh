#!/bin/sh

# Add github's ssh fingerprints
if ! grep -q "^github.com" ~/.ssh/known_hosts; then
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
fi

# Fetch latest package
git pull

# Install required packages
sudo yum install python3 git -y

# Install required pip packages
sudo pip3 install -r requirements.txt

# TODO Create cron task for update.sh if not present
# https://stackoverflow.com/questions/27227215/insert-entry-into-crontab-unless-it-already-exists-as-one-liner-if-possible
# grep 'sh honeydeck-sensor/update.sh' /etc/crontab || echo '*/5 *  *  *  * sh honeydeck-sensor/update.sh' >> /etc/crontab
