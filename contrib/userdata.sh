#!/bin/bash -xe

##################################################################
# Example Userdata Script 
# Can be used with AWS Launch Templates to create self-registering
# autoscaling groups for sensors
##################################################################

HONEYDECK_SERVER="< honeydeck_server_url_goes_here >"
SENSOR_GROUP_TOKEN="< sensor_group_token_goes_here >"

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
yum update -y --skip-broken
yum install git jq -y --skip-broken
su - ec2-user -c "cd ~ec2-user/ && git clone https://github.com/intercept-security/honeydeck-sensor.git"
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && ./install.sh"
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && cp honeydeck-sensor-sample.yml honeydeck-sensor.yml"
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor &&  python3 util/update_honeydeck_config.py honeydeck-sensor.yml sensor_name $instance_id"
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && python3 util/update_honeydeck_config.py honeydeck-sensor.yml sensor_group_token $SENSOR_GROUP_TOKEN"
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && python3 util/update_honeydeck_config.py honeydeck-sensor.yml honeydeck_server $HONEYDECK_SERVER"
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && ./register_sensor.sh"
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && ./update.sh"
