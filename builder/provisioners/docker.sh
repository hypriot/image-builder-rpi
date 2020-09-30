#!/bin/sh

# set up Docker CE repository
DOCKERREPO_FPR=9DC858229FC7DD38854AE2D88D81803C0EBFCD88
DOCKERREPO_KEY_URL=https://download.docker.com/linux/raspbian/gpg
get_gpg "${DOCKERREPO_FPR}" "${DOCKERREPO_KEY_URL}"

echo "deb [arch=armhf] https://download.docker.com/linux/raspbian buster $DOCKER_CE_CHANNEL" > /etc/apt/sources.list.d/docker.list

c_rehash

apt-get update -y

# install docker-machine
curl -sSL -o /usr/local/bin/docker-machine "https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-armhf"
chmod +x /usr/local/bin/docker-machine

# install bash completion for Docker Machine
curl -sSL "https://raw.githubusercontent.com/docker/machine/v${DOCKER_MACHINE_VERSION}/contrib/completion/bash/docker-machine.bash" -o /etc/bash_completion.d/docker-machine

# install docker-compose
apt-get install -y \
  --no-install-recommends \
  python3 python3-pip python3-setuptools
update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2
pip3 install "docker-compose==${DOCKER_COMPOSE_VERSION}"

# install bash completion for Docker Compose
curl -sSL "https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose" -o /etc/bash_completion.d/docker-compose

# install docker-ce (w/ install-recommends)
apt-get install -y --force-yes \
  --no-install-recommends \
  "docker-ce-cli=${DOCKER_CE_VERSION}" \
  "docker-ce=${DOCKER_CE_VERSION}"

# install bash completion for Docker CLI
curl -sSL https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker
