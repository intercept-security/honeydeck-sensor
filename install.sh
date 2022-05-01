#!/bin/bash
# get the installation type
UNAME=$(uname -a)

echo $UNAME

if $(uname -a | grep -q 'amzn'); then
  echo "Configuring fedora distribution"
  /bin/bash sensor/install_fedora.sh
elif $(uname -a | grep -q 'Ubuntu'); then
  echo "Configuring debian distribution"
  /bin/bash sensor/install_debian.sh
else
  echo "Incompatible Linux distribution, exiting..."
  exit 1
fi
