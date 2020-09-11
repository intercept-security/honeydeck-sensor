#!/bin/sh

# Add github's ssh fingerprints
if ! grep -q "^github.com" ~/.ssh/known_hosts; then
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
fi

# Install required packages
sudo yum install python3 git -y

# Install required pip packages
sudo pip3 -r install requirements.txt