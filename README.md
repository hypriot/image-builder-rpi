# image-builder-rpi
[![Join the chat at https://gitter.im/hypriot/talk](https://badges.gitter.im/hypriot/talk.svg)](https://gitter.im/hypriot/talk?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/hypriot/image-builder-rpi.svg)](https://travis-ci.org/hypriot/image-builder-rpi)

**Disclaimer:** This is work in progress and not yet finished. If you want a stable version of HypriotOS for the Raspberry Pi, go to our [download page](http://blog.hypriot.com/downloads/). But if you want to help us and give feedback for the upcoming HypriotOS please read on.

This repo builds the SD card image with HypriotOS for the Raspberry Pi. To build this SD card image we have to

 * take the files for the root filesystem from [`os-rootfs`](https://github.com/hypriot/os-rootfs)
 * take the empty raw filesystem from [`image-buidler-raw`](https://github.com/hypriot/image-builder-raw) with the two partitions
 * add Hypriot's Debian repos
 * install the Raspberry Pi kernel from [`rpi-kernel`](https://github.com/hypriot/rpi-kernel)
 * install Docker tools

Here is an example how all the GitHub repos play together:

![Architecture](http://blog.hypriot.com/images/hypriotos-xxx/hypriotos_buildpipeline.jpg)

## Contributing

You can contribute to this repo by forking it and sending us pull requests. Feedback is always welcome!

You can build the root filesystem locally with Vagrant.

## Setting up build environment
Make sure you have [vagrant](https://docs.vagrantup.com/v2/installation/) and [docker-machine](https://docs.docker.com/machine/install-machine/) installed.

A `vagrant up` in the root folder of this repository sets up a Ubuntu Trusty VM with the latest Docker installed.

To use this Docker instance from your host one can use `docker-machine`.  
To set it up with your Vagrant VM execute the following command:

```bash
docker-machine create -d generic \
  --generic-ssh-user $(vagrant ssh-config | grep ' User ' | awk '{print $2}') \
  --generic-ssh-key $(vagrant ssh-config | grep IdentityFile | awk '{gsub(/"/, "", $2); print $2}') \
  --generic-ip-address $(vagrant ssh-config | grep HostName | awk '{print $2}') \
  --generic-ssh-port $(vagrant ssh-config | grep Port | awk '{print $2}') \
  image-builder-rpi
```

Now set the Docker environments to this new docker machine:

```bash
eval $(docker-machine env image-builder-rpi)
```

From here you can...
  - ... just use `make` to make a new SD-Card image:

```bash
make sd-image
```

  - ... run tests:
```bash
make shell
./build.sh
rspec --format documentation --color test/image_spec.rb
```

## License

MIT - see the [LICENSE](./LICENSE) file for details.
