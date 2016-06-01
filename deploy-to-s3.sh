#!/bin/bash
set -e
VERSION=0.8.0

#wget https://github.com/hypriot/image-builder-rpi/releases/download/v${VERSION}/hypriotos-rpi-v${VERSION}.img.zip
#wget https://github.com/hypriot/image-builder-rpi/releases/download/v${VERSION}/hypriotos-rpi-v${VERSION}.img.zip.sha256

if [[ "${OSTYPE}" != "darwin"* ]]; then
  sha256sum -c hypriotos-rpi-v${VERSION}.img.zip.sha256
else
  shasum -a 256 -c hypriotos-rpi-v${VERSION}.img.zip.sha256
fi

aws s3 cp hypriotos-rpi-v${VERSION}.img.zip s3://buildserver-production/images/hypriotos-rpi-v${VERSION}.img.zip
aws s3 cp hypriotos-rpi-v${VERSION}.img.zip.sha256 s3://buildserver-production/images/hypriotos-rpi-v${VERSION}.img.zip.sha256
