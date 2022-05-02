#!/bin/bash

echo "Beginning Resonate Sensor Docker Entrypoint"

# Install the sensor
ansible-playbook sensor/install_sensor.yml

# Generate honeydeck_sensor.yml
cp ./honeydeck_sensor_sample.yml ./honeydeck_sensor.yml

echo "Updating Honeydeck Server URL"
python3 ./util/update_honeydeck_config.py honeydeck_sensor.yml honeydeck_server ${RS_PLATFORM_SERVER}

if [[ -n "${RS_SENSOR_TOKEN}" ]]; then
    echo "Updating Sensor Token"
    python3 ./util/update_honeydeck_config.py honeydeck_sensor.yml sensor_token ${RS_SENSOR_TOKEN}
fi

if [[ -n "${RS_SENSOR_GROUP_TOKEN}" ]]; then
    echo "Updating Sensor Group Token"
    python3 ./util/update_honeydeck_config.py honeydeck_sensor.yml sensor_group_token ${RS_SENSOR_GROUP_TOKEN}
fi

if [[ -n "${RS_SENSOR_NAME}" ]]; then
    echo "Updating Sensor Name"
    python3 ./util/update_honeydeck_config.py honeydeck_sensor.yml sensor_name ${RS_SENSOR_NAME}
fi

# Register the Sensor
echo "Registering the Sensor"
./register_sensor.sh

# Update the Sensor every 15 minutes
echo "Updating the Sensor"
while true; do
    ./update.sh
    echo "$(date) Updating Sensor Config every 15 minutes."
    sleep 900
done
