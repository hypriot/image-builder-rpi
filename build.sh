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

# what kernel to use
KERNEL_DATETIME=${KERNEL_DATETIME:="20151103-193133"}
KERNEL_VERSION=${KERNEL_VERSION:="4.1.12"}

IMAGE_NAME="sd-card-rpi.img"

# /etc/fstab template
FSTAB="
proc			/proc	proc	defaults	0	0
/dev/mmcblk0p1	/boot	vfat	defaults	0	0
/dev/mmcblk0p2	/	  	ext4	defaults,noatime       0       1
"

# size of root and boot partion
ROOT_PARTITION_SIZE="1400M"
BOOT_PARTITION_SIZE="64M"

# create build directory for assembling our image filesystem
rm -rf ${BUILD_PATH}
mkdir ${BUILD_PATH}

# download our base root file system
if [ ! -f "${ROOTFS_TAR_PATH}" ]; then
  wget -q -O ${ROOTFS_TAR_PATH} https://github.com/hypriot/os-rootfs/releases/download/v0.4/${ROOTFS_TAR}
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

# make our build directory the current root
# and install Rasberry Pi firmware and kernel packages
chroot ${BUILD_PATH} /bin/bash <<EOCHROOT
  # set up /etc/resolv.conf
  export DEST=\$(readlink -m /etc/resolv.conf)
  mkdir -p \$(dirname \$DEST)
  echo "nameserver 8.8.8.8" > \$DEST

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

  # create /etc/fstab
  echo "${FSTAB}" > /etc/fstab
  exit
EOCHROOT

umount -l ${BUILD_PATH}/dev/pts || true
umount -l ${BUILD_PATH}/dev || true
umount -l ${BUILD_PATH}/proc || true
umount -l ${BUILD_PATH}/sys || true

# package image filesytem into two tarballs - one for bootfs and one for rootfs
tar -czf /image_with_kernel_boot.tar.gz -C ${BUILD_PATH}/boot .
rm -Rf ${BUILD_PATH}/boot
tar -czf /image_with_kernel_root.tar.gz -C ${BUILD_PATH} .

# create the image and add root base filesystem
guestfish -N /${IMAGE_NAME}=bootroot:vfat:ext4:${ROOT_PARTITION_SIZE}:${BOOT_PARTITION_SIZE} <<_EOF_
        mount /dev/sda2 /
        tar-in /image_with_kernel_root.tar.gz / compress:gzip
        mkdir /boot
        mount /dev/sda1 /boot
        tar-in /image_with_kernel_boot.tar.gz /boot compress:gzip
        part-set-bootable /dev/sda 1 true
_EOF_

# test sd-image that we have built
rspec --format documentation --color /${BUILD_RESULT_PATH}/test

# ensure that the travis-ci user can access the sd-card image file
umask 0000

# compress image
pigz --zip -c "${IMAGE_NAME}" > "${BUILD_RESULT_PATH}/${IMAGE_NAME}.zip"
