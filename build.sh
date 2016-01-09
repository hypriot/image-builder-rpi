#!/bin/bash -e
set -x
# This script should be run only inside of a Docker container
if [ ! -f /.dockerinit ]; then
  echo "ERROR: script works only in a Docker container!"
  exit 1
fi

### setting up some important variables to control the build process

# where to store our created sd-image file
BUILD_RESULT="/workspace"

# where to store our base file system
ROOTFS_TAR="rootfs-armhf.tar.gz"
ROOTFS_TAR_PATH="${BUILD_RESULT}/${ROOTFS_TAR}"

# what kernel to use
KERNEL_DATETIME=${KERNEL_DATETIME:="20151103-193133"}
KERNEL_VERSION=${KERNEL_VERSION:="4.1.12"}

# building the name of our sd-card image file
IMAGE_NAME="sd-card-rpi.img"

# size of root and boot partion
ROOT_PARTITION_SIZE="1400M"
BOOT_PARTITION_SIZE="64M"

# download our base root file system
if [ ! -f "${ROOTFS_TAR_PATH}" ]; then
  wget -q -O ${ROOTFS_TAR_PATH} https://github.com/hypriot/os-rootfs/releases/download/v0.4/${ROOTFS_TAR}
fi

# create the image and add root base filesystem
guestfish -N /${IMAGE_NAME}=bootroot:vfat:ext4:${ROOT_PARTITION_SIZE}:${BOOT_PARTITION_SIZE} <<_EOF_
        mount /dev/sda2 /
        tar-in ${ROOTFS_TAR_PATH} / compress:gzip
_EOF_




# test sd-image that we have built
rspec --format documentation --color /${BUILD_RESULT}/test

pigz --zip -c "${IMAGE_NAME}" > "${BUILD_RESULT}/${IMAGE_NAME}.zip"
ls -lah ${BUILD_RESULT}
