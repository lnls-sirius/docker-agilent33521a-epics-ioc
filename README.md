Docker image for the Agilent 33521A Waveform Generator EPICS IOC
================================================================

This repository contains the Dockerfile used to create the Docker image with the
[EPICS IOC for the Agilent 33521A](https://github.com/lnls-dig/agilent33521a-epics-ioc).

## Running the IOC

The simples way to run the IOC is to run:

    docker run --rm -it --net host lnlsdig/agilent33521a-epics-ioc -i DEVICE_IP

where `DEVICE_IP` is the IP address of the device to connect to. The options you
can specify (after `lnlsdig/agilent33521a-epics-ioc`):

- `-i DEVICE_IP`: device IP address to connect to (required)
- `-p DEVICE_PORT`: device IP port number to connect to (default: 5025)
- `-P AREA_PREFIX`: the value of the EPICS `$(P)` macro used to prefix the PV names
- `-R DEVICE_PREFIX`: the value of the EPICS `$(R)` macro used to prefix the PV names

## Creating a Persistent Container

If you want to create a persistent container to run the IOC, you can run a
command similar to:

    docker run -it --net host --restart always --name CONTAINER_NAME lnlsdig/agilent33521a-epics-ioc -i DEVICE_IP

where `DEVICE_IP` is as in the previous section and `CONTAINER_NAME` is the name
given to the container. You can also use the same options as described in the
previous section.

## Building the Image Manually

To build the image locally without downloading it from Docker Hub, clone the
repository and run the `docker build` command:

    git clone https://github.com/lnls-dig/docker-agilent33521a-epics-ioc
    docker build -t lnlsdig/agilent33521a-epics-ioc docker-agilent33521a-epics-ioc
