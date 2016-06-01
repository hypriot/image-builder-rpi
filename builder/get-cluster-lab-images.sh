#!/bin/bash

source versions.config || source ../versions.config

# pull save and zip consul
docker pull hypriot/rpi-consul:"${CONSUL_VERSION}"
docker save --output=builder/files/var/local/rpi-consul_"${CONSUL_VERSION}".tar hypriot/rpi-consul:"${CONSUL_VERSION}"
gzip builder/files/var/local/rpi-consul_"${CONSUL_VERSION}".tar

# pull save and zip swarm
docker pull hypriot/rpi-swarm:"${SWARM_VERSION}"
docker save --output=builder/files/var/local/rpi-swarm_"${SWARM_VERSION}".tar hypriot/rpi-swarm:"${SWARM_VERSION}"
gzip builder/files/var/local/rpi-swarm_"${SWARM_VERSION}".tar
