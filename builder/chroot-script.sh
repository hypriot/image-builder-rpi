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
echo "+dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 cgroup-enable=memory swapaccount=1 elevator=deadline rootwait console=ttyAMA0,115200 kgdboc=ttyAMA0,115200" > /boot/cmdline.txt

# create a default boot/config.txt file (details see http://elinux.org/RPiconfig)
echo "
hdmi_force_hotplug=1
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

# install hypriot packages for docker-tools
apt-get install -y \
  "docker-hypriot=${DOCKER_ENGINE_VERSION}" \
  "docker-compose=${DOCKER_COMPOSE_VERSION}" \
  "docker-machine=${DOCKER_MACHINE_VERSION}" \
  "device-init=${DEVICE_INIT_VERSION}"

# enable Docker systemd service
systemctl enable docker

echo "Installing rpi-serial-console script"
wget -q https://raw.githubusercontent.com/lurch/rpi-serial-console/master/rpi-serial-console -O usr/local/bin/rpi-serial-console
chmod +x usr/local/bin/rpi-serial-console

# set device label and version number
echo "HYPRIOT_DEVICE=\"$HYPRIOT_DEVICE\"" >> /etc/os-release
echo "HYPRIOT_IMAGE_VERSION=\"$HYPRIOT_IMAGE_VERSION\"" >> /etc/os-release
