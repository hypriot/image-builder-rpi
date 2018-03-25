#!/bin/bash
set -ex

if ! [ -h /dev/disk/by-label/root ]; then
  echo "/dev/disk/by-label/root does not exist or is not a symlink. Don't know how to expand"
  return 0
fi

ROOT_PART=$(readlink /dev/disk/by-label/root)
PART_NUM=${ROOT_PART#../../mmcblk0p}
if [ "$PART_NUM" = "$ROOT_PART" ]; then
  echo "/dev/disk/by-label/root is not an SD card. Don't know how to expand"
  return 0
fi

# NOTE: the NOOBS partition layout confuses parted. For now, let's only
# agree to work with a sufficiently simple partition layout
if [ "$PART_NUM" -ne 2 ]; then
  echo "Your partition layout is not currently supported by this tool. You are probably using NOOBS, in which case your root filesystem is already expanded anyway."
  return 0
fi

LAST_PART_NUM=$(parted /dev/mmcblk0 -ms unit s p | tail -n 1 | cut -f 1 -d:)

if [ "$LAST_PART_NUM" != "$PART_NUM" ]; then
  echo "/dev/disk/by-label/root is not the last partition. Don't know how to expand"
  return 0
fi

# Get the starting offset of the root partition
PART_START=$(parted /dev/mmcblk0 -ms unit s p | grep "^${PART_NUM}" | cut -f 2 -d:)
# remove trailing 's'
PART_START=${PART_START::-1}
[ "$PART_START" ] || return 1
# Return value will likely be error for fdisk as it fails to reload the
# partition table because the root fs is mounted
set +e
fdisk /dev/mmcblk0 <<EOF
p
d
$PART_NUM
n
p
$PART_NUM
$PART_START

p
w
EOF
set -e

partprobe
/sbin/resize2fs /dev/disk/by-label/root
