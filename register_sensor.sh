#!/bin/sh

###### Honeydeck Sensor Registration Script ######

LOG_DIR=/var/log/honeydeck/sensor
LOG_FILE="${LOG_DIR}/log.txt"


HONEYDECK_CONFIG_FILE="honeydeck-sensor.yml"

sudo mkdir -p ${LOG_DIR}
sudo touch ${LOG_FILE}

sudo echo "###### $(date) Performing Sensor Registration ######" | sudo tee -a ${LOG_FILE}

SENSOR_NAME="$(yq -r .sensor_name "$HONEYDECK_CONFIG_FILE")"
SENSOR_GROUP_TOKEN="$(yq -r .sensor_group_token "$HONEYDECK_CONFIG_FILE")"
HONEYDECK_SERVER="$(yq -r .honeydeck_server "$HONEYDECK_CONFIG_FILE")"
HONEYDECK_REGISTER_URL="$HONEYDECK_SERVER/api/v1/sensors/discovery/"
EXISTING_HONEYDECK_TOKEN="$(yq -r .honeydeck_token "$HONEYDECK_CONFIG_FILE")"
FORCE_REGISTER="$1"

# Check if this sensor already has a token, continue if user adds flag
if [ "$EXISTING_HONEYDECK_TOKEN" != "null" ] && [ ! -z "$EXISTING_HONEYDECK_TOKEN" ]
then
    if [ "$FORCE_REGISTER" != "--ignore-existing-token" ]
    then
        echo "ERROR: 'honeydeck_token' is already set in HONEYDECK_CONFIG_FILE" | sudo tee -a ${LOG_FILE}
        echo "ERROR: This could create duplicate entries if unintended." | sudo tee -a ${LOG_FILE}
        echo "ERROR: If you want to re-register this sensor anyway, append '--ignore-existing-token' to this command." | sudo tee -a ${LOG_FILE}
        echo "ERROR: Example: './register_sensor.sh --ignore-existing-token'" | sudo tee -a ${LOG_FILE}
        exit 1
    else
        echo "INFO: '--ignore-existing-token' set - proceeding with registration." | sudo tee -a ${LOG_FILE}
    fi
fi

# Check that 'honeydeck_server' and 'sensor_group_token' are set in $HONEYDECK_CONFIG_FILE
if [ "$HONEYDECK_SERVER" == "null" ] || [ "$SENSOR_GROUP_TOKEN" == "null" ]
then
    echo "ERROR: 'honeydeck_server' and 'sensor_group_token' must be set in "$HONEYDECK_CONFIG_FILE"" | sudo tee -a ${LOG_FILE}
    exit 1
fi

# Determine if 'sensor_name' should be used from config file or from server and set value
if [ "$SENSOR_NAME" == "null" ] || [ -z "$SENSOR_NAME" ]
then
    echo "INFO: 'sensor_name' not set in "$HONEYDECK_CONFIG_FILE". Name will be generated by server." | sudo tee -a ${LOG_FILE}
    echo "INFO: Proceeding..." | sudo tee -a ${LOG_FILE}
else
    curl_payload_string="-d {\"name\":\"$SENSOR_NAME\"}"
fi

# Attempt to register sensor with server and collect values
server_response="$(curl -s -X POST $curl_payload_string -H "Content-Type: application/json" -H "Accept: application/json" -H "Honeydeck-Group-Token: $SENSOR_GROUP_TOKEN" "$HONEYDECK_REGISTER_URL")"

# Display error from server if unsuccessful
if [ $? -gt 0 ]
then
    error_message="$(echo "$server_response" | yq -r .message)"
    echo "ERROR: Failed to register new sensor." | sudo tee -a ${LOG_FILE}
    echo "ERROR: Message from server: $error_message" | sudo tee -a ${LOG_FILE}
    exit 1
fi

new_name="$(echo "$server_response" | yq -r .name)"
new_token="$(echo "$server_response" | yq -r .token)"

# Update config file with new values
echo "INFO: Updating $HONEYDECK_CONFIG_FILE with new values" | sudo tee -a ${LOG_FILE}
python3 util/update_honeydeck_config.py "$HONEYDECK_CONFIG_FILE" sensor_name "$new_name"
python3 util/update_honeydeck_config.py "$HONEYDECK_CONFIG_FILE" honeydeck_token "$new_token"

# Complete
sudo echo "###### $(date) Completed Sensor Registration ######" | sudo tee -a ${LOG_FILE}
