#!/bin/bash -e
set -x
# This script should be run only inside of a Docker container
if [ ! -f /.dockerenv ]; then
  echo "ERROR: script works only in a Docker container!"
  exit 1
fi

### setting up some important variables to control the build process

# place to store our created sd-image file
BUILD_RESULT_PATH="/workspace"

# place to build our sd-image
BUILD_PATH="/build"

# config vars for the root file system
HYPRIOT_OS_VERSION="v0.8.6"
ROOTFS_TAR_CHECKSUM="d1b9642317d5154ddfe5042b21232d10a036ff677cf100bcf916da81a5c811ad"
ROOTFS_TAR="rootfs-armhf-raspbian-${HYPRIOT_OS_VERSION}.tar.gz"
ROOTFS_TAR_PATH="${BUILD_RESULT_PATH}/${ROOTFS_TAR}"

# Show TRAVSI_TAG in travis builds
echo TRAVIS_TAG="${TRAVIS_TAG}"

# name of the ready made raw image for RPi
RAW_IMAGE="rpi-raw.img"
RAW_IMAGE_VERSION="v0.1.4"
RAW_IMAGE_CHECKSUM="a242769dec546dbda335204d4e6bb4eb64685009d235a2a881605bdf44766b0a"

# name of the sd-image we gonna create
HYPRIOT_IMAGE_VERSION=${VERSION:="dirty"}
HYPRIOT_IMAGE_NAME="hypriotos-rpi-${HYPRIOT_IMAGE_VERSION}.img"
export HYPRIOT_IMAGE_VERSION

# specific versions of kernel/firmware and docker tools
export KERNEL_BUILD="20160520-141137"
export KERNEL_VERSION="4.4.10"
export DOCKER_ENGINE_VERSION="1.11.1-1"
export DOCKER_COMPOSE_VERSION="1.7.1-40"
export DOCKER_MACHINE_VERSION="0.7.0-26"
export DEVICE_INIT_VERSION="0.1.7"
export CLUSTER_LAB_VERSION="0.2.12-1"

# create build directory for assembling our image filesystem
rm -rf ${BUILD_PATH}
mkdir ${BUILD_PATH}

# download our base root file system
if [ ! -f "${ROOTFS_TAR_PATH}" ]; then
  wget -q -O ${ROOTFS_TAR_PATH} https://github.com/hypriot/os-rootfs/releases/download/${HYPRIOT_OS_VERSION}/${ROOTFS_TAR}
fi

# verify checksum of our root filesystem
echo "${ROOTFS_TAR_CHECKSUM} ${ROOTFS_TAR_PATH}" | sha256sum -c -

# extract root file system
tar xf ${ROOTFS_TAR_PATH} -C ${BUILD_PATH}

# register qemu-arm with binfmt
# to ensure that binaries we use in the chroot
# are executed via qemu-arm
update-binfmts --enable qemu-arm

# set up mount points for the pseudo filesystems
mkdir -p ${BUILD_PATH}/{proc,sys,dev/pts}

mount -o bind /dev ${BUILD_PATH}/dev
mount -o bind /dev/pts ${BUILD_PATH}/dev/pts
mount -t proc none ${BUILD_PATH}/proc
mount -t sysfs none ${BUILD_PATH}/sys

# modify/add image files directly
# e.g. root partition resize script
cp -R /builder/files/* ${BUILD_PATH}/

# make our build directory the current root
# and install the Rasberry Pi firmware, kernel packages,
# docker tools and some customizations
chroot ${BUILD_PATH} /bin/bash < /builder/chroot-script.sh

# unmount pseudo filesystems
umount -l ${BUILD_PATH}/dev/pts
umount -l ${BUILD_PATH}/dev
umount -l ${BUILD_PATH}/proc
umount -l ${BUILD_PATH}/sys

# package image filesytem into two tarballs - one for bootfs and one for rootfs
# ensure that there are no leftover artifacts in the pseudo filesystems
rm -rf ${BUILD_PATH}/{dev,sys,proc}/*

tar -czf /image_with_kernel_boot.tar.gz -C ${BUILD_PATH}/boot .
rm -Rf ${BUILD_PATH}/boot
tar -czf /image_with_kernel_root.tar.gz -C ${BUILD_PATH} .

# download the ready-made raw image for the RPi
if [ ! -f "${BUILD_RESULT_PATH}/${RAW_IMAGE}.zip" ]; then
  wget -q -O ${BUILD_RESULT_PATH}/${RAW_IMAGE}.zip https://github.com/hypriot/image-builder-raw/releases/download/${RAW_IMAGE_VERSION}/${RAW_IMAGE}.zip
fi

# verify checksum of the ready-made raw image
echo "${RAW_IMAGE_CHECKSUM} ${BUILD_RESULT_PATH}/${RAW_IMAGE}.zip" | sha256sum -c -

unzip -p ${BUILD_RESULT_PATH}/${RAW_IMAGE} > "/${HYPRIOT_IMAGE_NAME}"

# create the image and add root base filesystem
guestfish -a "/${HYPRIOT_IMAGE_NAME}"<<_EOF_
  run
  #import filesystem content
  mount /dev/sda2 /
  tar-in /image_with_kernel_root.tar.gz / compress:gzip
  mkdir /boot
  mount /dev/sda1 /boot
  tar-in /image_with_kernel_boot.tar.gz /boot compress:gzip
_EOF_

# ensure that the travis-ci user can access the sd-card image file
umask 0000

# compress image
zip "${BUILD_RESULT_PATH}/${HYPRIOT_IMAGE_NAME}.zip" "${HYPRIOT_IMAGE_NAME}"
cd ${BUILD_RESULT_PATH} && sha256sum "${HYPRIOT_IMAGE_NAME}.zip" > "${HYPRIOT_IMAGE_NAME}.zip.sha256" && cd -

# test sd-image that we have built
VERSION=${HYPRIOT_IMAGE_VERSION} rspec --format documentation --color ${BUILD_RESULT_PATH}/builder/test
