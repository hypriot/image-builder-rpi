#!/bin/bash -e
set -x
# This script should be run inside of a Docker container only
if [ ! -f /.dockerinit ]; then
  echo "ERROR: script works in Docker only!"
  exit 1
fi

# setting up some important variables to control the build process
KERNEL_DATETIME=${KERNEL_DATETIME:="20151103-193133"}
KERNEL_VERSION=${KERNEL_VERSION:="4.1.12"}

SD_CARD_SIZE="1500"        # "1500" = approx. 1.5 GB
BOOT_PARTITION_SIZE="64"   # "64" = 64 MB

_FSTAB="
proc			/proc	proc	defaults	0	0
/dev/mmcblk0p1	/boot	vfat	defaults	0	0
/dev/mmcblk0p2	/	  	ext4	defaults,noatime       0       1
"

BOOTFS_START=2048
BOOTFS_SIZE=$(expr ${BOOT_PARTITION_SIZE} \* 2048)
ROOTFS_START=$(expr ${BOOTFS_SIZE} + ${BOOTFS_START})
SD_MINUS_DD=$(expr ${SD_CARD_SIZE} - 256)
ROOTFS_SIZE=$(expr ${SD_MINUS_DD} \* 1000000 / 512 - ${ROOTFS_START})

BUILD_TIME="$(date +%Y%m%d-%H%M%S)"
IMAGE_PATH="/data/image_builder_rpi-${BUILD_TIME}.img"

echo "Creating image"
dd if=/dev/zero of=${IMAGE_PATH} bs=1MB count=${SD_CARD_SIZE}





