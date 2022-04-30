# honeydeck-sensor

## Standard Installation
- Download the latest release: https://github.com/intercept-security/honeydeck-sensor/releases/
- Extract (`tar` or `zip`)
- Copy `honeydeck_sensor_sample.yml` to `honeydeck_sensor.yml`
- Edit `honeydeck_sensor.yml`
  - Add `honeydeck_token` or `sensor_group_token`
  - Add `honeydeck_server`
  - Add `sensor_name` (optionally)
- Run `./install.sh` as a user with sudo privileges
- Run `./update.sh` as a user with sudo privileges

**Tested on Amazon Linux, using ec2-user**


## Docker Installation

### Building
To build / update the docker image, run:
```bash
docker build -t resonate-sensor-dev .
```

### Running in Development

Make a copy of [docker/docker_RS.env](docker/docker_RS_sample.env), and then edit the necessary variables.

```bash
cp docker/docker_RS_sample.env
vim docker/docker_RS_sample.env
```

For development purposes, you can use something like:
```bash
docker run -p 2222:22 --env-file docker/docker_RS.env -itd resonate-sensor
```

This will use the environment variables set in `docker/docker_RS.env` and map port 2222 to the honeypot port on the sensor.

This has a major caveat: `src_ip` data will always show as the docker bridge/router IP address, typically `172.17.0.1`. The benefit is that the host machine does not have to relocate its `ssh` port.


#### Running in Production

In order to report the correct `src_ip`, the container must be run in "host" mode. This runs the container on the host's network stack rather than via the docker bridge.

In order for this to work, the host machine must have port 22 open and available for use ([for example, the default SSH service should be relocated](https://docs.rackspace.com/support/how-to/change-the-ssh-port-in-centos-and-redhat/)).

Make a copy of [docker/docker_RS.env](docker/docker_RS_sample.env), and then edit the necessary variables.

```bash
cp docker/docker_RS_sample.env
vim docker/docker_RS_sample.env
```

Afterwards, you can run: 
```bash
docker run --net=host --env-file docker/docker_RS.env -itd resonate-sensor
```

Port 22 on the host will be occupied by the container's cowrie service, and ready for potential attackers.
