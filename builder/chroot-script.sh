#!/bin/bash

set -euxo pipefail

# device specific settings
HYPRIOT_DEVICE="Raspberry Pi"
RELEASE="stretch" # todo ideally this should be retrieved from a command like lsb_release, but it is installed later.

# set up /etc/resolv.conf
DEST=$(readlink -m /etc/resolv.conf)
export DEST
mkdir -p "$(dirname "${DEST}")"
echo "nameserver 8.8.8.8" > "${DEST}"

export DEBIAN_FRONTEND=noninteractive

# Install dirmngr to allow downloading apt keys from keyserver
apt-get update && apt-get install -y dirmngr

# set up hypriot rpi repository for rpi specific kernel- and firmware-packages
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2E73424D59097AB
echo "deb https://packagecloud.io/Hypriot/rpi/debian/ ${RELEASE} main" > /etc/apt/sources.list.d/hypriot.list

# set up Docker CE repository
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7EA0A9C3F273FCD8
echo "deb [arch=armhf] https://download.docker.com/linux/raspbian ${RELEASE} ${DOCKER_CHANNEL}" > /etc/apt/sources.list.d/docker.list

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 82B129927FA3303E
echo "deb http://archive.raspberrypi.org/debian ${RELEASE} main" > /etc/apt/sources.list.d/raspberrypi.list

# reload package sources
apt-get update
apt-get upgrade -y

# install WiFi firmware packages (same as in Raspbian)
apt-get install -y \
  --no-install-recommends \
  firmware-atheros \
  firmware-brcm80211 \
  firmware-libertas \
  firmware-misc-nonfree \
  firmware-realtek

# install kernel- and firmware-packages
apt-get install -y \
  --no-install-recommends \
  raspberrypi-bootloader \
  libraspberrypi0 \
  libraspberrypi-bin \
  raspi-config

# install special Docker enabled kernel
if [[ -z ${KERNEL_URL+x} ]]; then
  apt-get install -y \
    --no-install-recommends \
    "raspberrypi-kernel=${KERNEL_BUILD}"
else
  curl -L -o /tmp/kernel.deb "${KERNEL_URL}"
  dpkg -i /tmp/kernel.deb
  rm /tmp/kernel.deb
fi

# enable serial console
printf "# Spawn a getty on Raspberry Pi serial line\nT0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100\n" >> /etc/inittab

# boot/cmdline.txt
echo "dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 cgroup_enable=cpuset cgroup_enable=memory swapaccount=1 elevator=deadline fsck.repair=yes rootwait quiet init=/usr/lib/raspi-config/init_resize.sh" > /boot/cmdline.txt

# create a default boot/config.txt file (details see http://elinux.org/RPiconfig)
echo "
hdmi_force_hotplug=1
enable_uart=0
" > boot/config.txt

echo "# camera settings, see http://elinux.org/RPiconfig#Camera
start_x=0
disable_camera_led=1
gpu_mem=16
" >> boot/config.txt

# /etc/modules
echo "snd_bcm2835
" >> /etc/modules

# create /etc/fstab
echo "
proc /proc proc defaults 0 0
/dev/mmcblk0p1 /boot vfat defaults 0 0
/dev/mmcblk0p2 / ext4 defaults,noatime 0 1
" > /etc/fstab

# as the Pi does not have a hardware clock we need a fake one
apt-get install --assume-yes \
  --no-install-recommends \
  fake-hwclock

# install packages for managing wireless interfaces
apt-get install --assume-yes \
  --no-install-recommends \
  wpasupplicant \
  wireless-tools \
  crda \
  raspberrypi-net-mods

# add firmware and packages for managing bluetooth devices
apt-get install --assume-yes \
  --no-install-recommends \
  pi-bluetooth

# ensure compatibility with Docker install.sh, so `raspbian` will be detected correctly
apt-get install --assume-yes \
  --no-install-recommends \
  lsb-release \
  gettext

# install python
apt-get install --assume-yes \
  --no-install-recommends \
  python3-pip \
  python3-setuptools

ln -s /usr/bin/pip3 /usr/bin/pip
ln -s /usr/bin/python3 /usr/bin/python
pip install pip --upgrade # this requires logging out and logging back in to be able to simply use pip due to some bug.
# Instead use "python -m pip <args>", after logout and back in, pip install etc should work.

# install cloud-init
curl -fsSL "https://launchpad.net/ubuntu/+archive/primary/+files/cloud-init_${CLOUD_INIT_VERSION}_all.deb" -o /tmp/cloud-init.deb
dpkg --install --force-depends --force-confold /tmp/cloud-init.deb
apt-get install --fix-broken --assume-yes

# Link cloud-init config to VFAT /boot partition
mkdir -p /var/lib/cloud/seed/nocloud-net
ln -s /boot/user-data /var/lib/cloud/seed/nocloud-net/user-data
ln -s /boot/meta-data /var/lib/cloud/seed/nocloud-net/meta-data

# Fix duplicate IP address for eth0, remove file from os-rootfs
rm -f /etc/network/interfaces.d/eth0

# install docker-ce (w/ install-recommends)
apt-get install --assume-yes --allow-downgrades \
  --no-install-recommends \
  "docker-ce=${DOCKER_CE_VERSION}"

# install bash completion
declare -A downloads=(
    ["/etc/bash_completion.d/docker-machine"]="https://raw.githubusercontent.com/docker/machine/v${DOCKER_MACHINE_VERSION}/contrib/completion/bash/docker-machine.bash"
    ["/etc/bash_completion.d/docker-compose"]="https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose"
    ["/etc/bash_completion.d/docker"]="https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker"
    ["/usr/local/bin/docker-machine"]="https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-armhf"
    ["/usr/local/bin/rpi-serial-console"]="https://raw.githubusercontent.com/lurch/rpi-serial-console/master/rpi-serial-console"
)
for file in "${!downloads[@]}"; do
    curl -fsSL "${downloads[$file]}" -o "$file"
done
chmod +x /usr/local/bin/docker-machine
chmod +x /usr/local/bin/rpi-serial-console

python -m pip install "docker-compose==${DOCKER_COMPOSE_VERSION}"

# fix eth0 interface name
ln -s /dev/null /etc/systemd/network/99-default.link

# cleanup APT cache and lists
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set device label and version number
echo "HYPRIOT_DEVICE=\"$HYPRIOT_DEVICE\"" >> /etc/os-release
echo "HYPRIOT_IMAGE_VERSION=\"$HYPRIOT_IMAGE_VERSION\"" >> /etc/os-release
cp /etc/os-release /boot/os-release
