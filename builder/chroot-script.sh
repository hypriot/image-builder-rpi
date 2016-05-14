#!/bin/bash
set -ex

# device specific settings
HYPRIOT_DEVICE="Raspberry Pi"

# set up /etc/resolv.conf
DEST=$(readlink -m /etc/resolv.conf)
export DEST
mkdir -p "$(dirname "${DEST}")"
echo "nameserver 8.8.8.8" > "${DEST}"

# set up hypriot rpi repository for rpi specific kernel- and firmware-packages
wget -q https://packagecloud.io/gpg.key -O - | apt-key add -
echo 'deb https://packagecloud.io/Hypriot/rpi/debian/ jessie main' > /etc/apt/sources.list.d/hypriot.list

# set up hypriot schatzkiste repository for generic packages
echo 'deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy main' >> /etc/apt/sources.list.d/hypriot.list

wget -q -O - http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add -
echo 'deb http://archive.raspberrypi.org/debian/ jessie main' | tee /etc/apt/sources.list.d/raspberrypi.list

# reload package sources
apt-get update

# install WiFi firmware packages (same as in Raspbian)
apt-get install -y \
  firmware-atheros \
  firmware-brcm80211 \
  firmware-libertas \
  firmware-ralink \
  firmware-realtek

# install kernel- and firmware-packages
apt-get install -y \
  "raspberrypi-bootloader=${KERNEL_BUILD}" \
  "libraspberrypi0=${KERNEL_BUILD}" \
  "libraspberrypi-dev=${KERNEL_BUILD}" \
  "libraspberrypi-bin=${KERNEL_BUILD}" \
  "libraspberrypi-doc=${KERNEL_BUILD}" \
  "linux-headers-${KERNEL_VERSION}-hypriotos-v7+" \
  "linux-headers-${KERNEL_VERSION}-hypriotos+"

# enable serial console
printf "# Spawn a getty on Raspberry Pi serial line\nT0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100\n" >> /etc/inittab

# boot/cmdline.txt
echo "+dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 cgroup_enable=memory swapaccount=1 elevator=deadline fsck.repair=yes rootwait console=ttyAMA0,115200 kgdboc=ttyAMA0,115200" > /boot/cmdline.txt

# create a default boot/config.txt file (details see http://elinux.org/RPiconfig)
echo "
hdmi_force_hotplug=1
core_freq=250
" > boot/config.txt

# /etc/modules
echo "vchiq
snd_bcm2835
bcm2708-rng
" >> /etc/modules

# create /etc/fstab
echo "
proc /proc proc defaults 0 0
/dev/mmcblk0p1 /boot vfat defaults 0 0
/dev/mmcblk0p2 / ext4 defaults,noatime 0 1
" > /etc/fstab

# as the Pi does not have a hardware clock we need a fake one
apt-get install -y \
  fake-hwclock

# install packages for managing wireless interfaces
apt-get install -y \
  wpasupplicant \
  wireless-tools \
  ethtool \
  crda

# add firmware and packages for managing bluetooth devices
apt-get install -y \
  --no-install-recommends \
  bluetooth \
  pi-bluetooth

# install hypriot packages for docker-tools
apt-get install -y \
  "docker-engine=${DOCKER_ENGINE_VERSION}" \
  "docker-compose=${DOCKER_COMPOSE_VERSION}" \
  "docker-machine=${DOCKER_MACHINE_VERSION}" \
  "device-init=${DEVICE_INIT_VERSION}"

# enable Docker systemd service
systemctl enable docker


echo "Installing rpi-serial-console script"
wget -q https://raw.githubusercontent.com/lurch/rpi-serial-console/master/rpi-serial-console -O usr/local/bin/rpi-serial-console
chmod +x usr/local/bin/rpi-serial-console

# store Docker Swarm and Consul image files for preloading via device-init
wget -q https://github.com/hypriot/rpi-swarm/releases/download/v1.2.2/rpi-swarm_v1.2.2.tar.gz -O var/local/rpi-swarm_v1.2.2.tar.gz
wget -q https://github.com/hypriot/rpi-consul/releases/download/v0.6.4/rpi-consul_v0.6.4.tar.gz -O var/local/rpi-consul_v0.6.4.tar.gz

# install Hypriot Cluster-Lab
apt-get install -y \
  "hypriot-cluster-lab=${CLUSTER_LAB_VERSION}"
# do not run cluster-lab automatically
systemctl disable cluster-lab.service

# set device label and version number
echo "HYPRIOT_DEVICE=\"$HYPRIOT_DEVICE\"" >> /etc/os-release
echo "HYPRIOT_IMAGE_VERSION=\"$HYPRIOT_IMAGE_VERSION\"" >> /etc/os-release
cp /etc/os-release /boot/os-release
