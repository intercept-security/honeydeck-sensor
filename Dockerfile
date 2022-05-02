# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 ubuntu:latest
LABEL MAINTAINER='David Anderson "david.anderson@resonate.security"'

ENV RS_IS_DOCKER=true
RUN apt-get update -y -qq \
    && apt-get install -y -qq sudo unzip python3-venv python3-pip libcap2-bin \
    && sudo pip3 install ansible ruamel.yaml
RUN useradd -m -d /app resonate -s /usr/bin/bash \
    && echo "resonate ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
USER resonate
COPY . /app
RUN sudo chown -R resonate:resonate /app
WORKDIR /app

ENTRYPOINT ["./docker/entrypoint.sh"]
EXPOSE 22/tcp
