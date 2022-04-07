#!/bin/bash -xe

##################################################################
# Example Userdata Script 
# Can be used with AWS Launch Templates to create self-registering
# autoscaling groups for sensors
# Tested with Amazon Linux 2
##################################################################

HONEYDECK_SERVER="< honeydeck_server_url_goes_here >"
SENSOR_GROUP_TOKEN="< sensor_group_token_goes_here >"

amazon-linux-extras install epel -y

yum update -y
yum upgrade -y

yum -y install fail2ban git jq
systemctl enable fail2ban
systemctl start fail2ban

su - ec2-user -c "cd ~ec2-user && git clone https://github.com/intercept-security/honeydeck-sensor.git"

instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && echo 'sensor_name: $instance_id' >> honeydeck_sensor.yml"

su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && echo 'honeydeck_server: $HONEYDECK_SERVER' >> honeydeck_sensor.yml"
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && echo 'sensor_group_token: $SENSOR_GROUP_TOKEN' >> honeydeck_sensor.yml"
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && echo 'sensor_roles: [ \"ssh_honeypot\" ]' >> honeydeck_sensor.yml"

su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && ./install.sh"
su - ec2-user -c "cd ~ec2-user/honeydeck-sensor && ./register_sensor.sh"
