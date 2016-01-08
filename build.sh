#!/bin/bash -e
set -x
# This script should be run inside of a Docker container only
if [ ! -f /.dockerinit ]; then
  echo "ERROR: script works in Docker only!"
  exit 1
fi

echo "Running build.sh"
