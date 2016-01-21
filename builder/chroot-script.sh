#!/bin/bash -ex

# set up /etc/resolv.conf
export DEST=$(readlink -m /etc/resolv.conf)
mkdir -p $(dirname $DEST)
echo "nameserver 8.8.8.8" > $DEST

# set up hypriot repository
# and install RPi kernel and firmware
apt-get update

# set up hypriot rpi repository for rpi specific kernel- and firmware-packages
wget -q https://packagecloud.io/gpg.key -O - | apt-key add -
echo 'deb https://packagecloud.io/Hypriot/rpi/debian/ jessie main' > /etc/apt/sources.list.d/hypriot.list

# set up hypriot schatzkiste repository for generic packages
echo 'deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy main' >> /etc/apt/sources.list.d/hypriot.list

# reload package sources
apt-get update

# install kernel- and firmware-packages
apt-get install -y \
  raspberrypi-bootloader \
  libraspberrypi0 \
  libraspberrypi-dev \
  libraspberrypi-bin \
  libraspberrypi-doc \
  linux-headers-4.1.12-hypriotos-v7+ \
  linux-headers-4.1.12-hypriotos+

# enable serial console
printf "# Spawn a getty on Raspberry Pi serial line\nT0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100\n" >> /etc/inittab

# boot/cmdline.txt
echo "+dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 cgroup-enable=memory swapaccount=1 elevator=deadline rootwait console=ttyAMA0,115200 kgdboc=ttyAMA0,115200" > /boot/cmdline.txt

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
  docker-hypriot \
  docker-compose \
  docker-machine

# enable Docker systemd service
systemctl enable docker
