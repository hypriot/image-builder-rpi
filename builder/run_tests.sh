#!/bin/bash
export PROVISIONER=${PROVISIONER:=docker}

unzip "/workspace/hypriotos-rpi-${VERSION}-${PROVISIONER}.img.zip" && rspec --format documentation --color /workspace/builder/test/*_spec.rb