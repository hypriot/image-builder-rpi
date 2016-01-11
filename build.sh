#!/bin/bash -e
set -x
# This script should be run only inside of a Docker container
if [ ! -f /.dockerinit ]; then
  echo "ERROR: script works only in a Docker container!"
  exit 1
fi

### setting up some important variables to control the build process

# where to store our created sd-image file
BUILD_RESULT_PATH="/workspace"
BUILD_PATH="/build"

# where to store our base file system
ROOTFS_TAR="rootfs-armhf.tar.gz"
ROOTFS_TAR_PATH="${BUILD_RESULT_PATH}/${ROOTFS_TAR}"
ROOTFS_TAR_VERSION="v0.4"

# where to store our raw image
RAW_IMAGE="rpi-raw.img"

# what kernel to use
KERNEL_DATETIME=${KERNEL_DATETIME:="20151103-193133"}
KERNEL_VERSION=${KERNEL_VERSION:="4.1.12"}

IMAGE_NAME="sd-card-rpi.img"

# size of root and boot partion in Megabytes
ROOT_PARTITION_SIZE="1435"
BOOT_PARTITION_SIZE="64"

# create build directory for assembling our image filesystem
rm -rf ${BUILD_PATH}
mkdir ${BUILD_PATH}

# download our base root file system
if [ ! -f "${ROOTFS_TAR_PATH}" ]; then
  wget -q -O ${ROOTFS_TAR_PATH} https://github.com/hypriot/os-rootfs/releases/download/${ROOTFS_TAR_VERSION}/${ROOTFS_TAR}
fi

# extract root file system
tar xf ${ROOTFS_TAR_PATH} -C ${BUILD_PATH}

# register qemu-arm with binfmt
update-binfmts --enable qemu-arm

# set up mount points for pseudo filesystems
mkdir -p ${BUILD_PATH}/{proc,sys,dev/pts}

mount -o bind /dev ${BUILD_PATH}/dev
mount -o bind /dev/pts ${BUILD_PATH}/dev/pts
mount -t proc none ${BUILD_PATH}/proc
mount -t sysfs none ${BUILD_PATH}/sys

#make our build directory the current root
#and install Rasberry Pi firmware and kernel packages
chroot ${BUILD_PATH} /bin/bash <<"EOCHROOT"
  # set up /etc/resolv.conf
  export DEST=$(readlink -m /etc/resolv.conf)
  mkdir -p $(dirname $DEST)
  echo "nameserver 8.8.8.8" > $DEST

  # set up hypriot repository
  apt-get update
  wget -q https://packagecloud.io/gpg.key -O - | apt-key add -
  echo 'deb https://packagecloud.io/Hypriot/rpi/debian/ jessie main' > /etc/apt/sources.list.d/hypriot.list
  apt-get update
  apt-get install -y raspberrypi-bootloader
  apt-get install -y libraspberrypi0
  apt-get install -y libraspberrypi-dev
  apt-get install -y libraspberrypi-bin
  apt-get install -y libraspberrypi-doc
  apt-get install -y linux-headers-4.1.12-hypriotos-v7+
  apt-get install -y linux-headers-4.1.12-hypriotos+

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
  exit
EOCHROOT

umount -l ${BUILD_PATH}/dev/pts
umount -l ${BUILD_PATH}/dev
umount -l ${BUILD_PATH}/proc
umount -l ${BUILD_PATH}/sys

# package image filesytem into two tarballs - one for bootfs and one for rootfs
rm -rf ${BUILD_PATH}/{dev,sys,proc}/*

tar -czf /image_with_kernel_boot.tar.gz -C ${BUILD_PATH}/boot .
rm -Rf ${BUILD_PATH}/boot
tar -czf /image_with_kernel_root.tar.gz -C ${BUILD_PATH} .

#download our base root file system
if [ ! -f "${BUILD_RESULT_PATH}/${RAW_IMAGE}.zip" ]; then
  wget -q -O ${BUILD_RESULT_PATH}/${RAW_IMAGE}.zip https://github.com/hypriot/image-builder-raw/releases/download/v0.0.5/${RAW_IMAGE}.zip
  unzip ${BUILD_RESULT_PATH}/${RAW_IMAGE}
fi

rm -f /${IMAGE_NAME}
cp ${RAW_IMAGE} /${IMAGE_NAME}

# create the image and add root base filesystem
guestfish -a "/${IMAGE_NAME}"<<_EOF_
  run
  #import filesystem content
  mount /dev/sda2 /
  tar-in /image_with_kernel_root.tar.gz / compress:gzip
  mkdir /boot
  mount /dev/sda1 /boot
  tar-in /image_with_kernel_boot.tar.gz /boot compress:gzip
_EOF_

# test sd-image that we have built
rspec --format documentation --color /${BUILD_RESULT_PATH}/test

# ensure that the travis-ci user can access the sd-card image file
umask 0000

# compress image
zip ${BUILD_RESULT_PATH}/${IMAGE_NAME}.zip ${IMAGE_NAME}
