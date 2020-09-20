FROM centos:8

WORKDIR /code
ADD . /code/sensor/

WORKDIR /code/sensor
RUN bash install.sh