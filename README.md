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

A `vagrant up` in the root folder of this repository sets up a Ubuntu Trusty VM with the latest Docker installed. We need this Vagrant box as a vanilla boot2docker VM is not able to run guestfish properly.

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

or just the following as a shortcut to spin up the Vagrant box and create the Docker Machine connection:

```bash
make docker-machine
```

Now set the Docker environments to this new docker machine:

```bash
eval $(docker-machine env image-builder-rpi)
```

### Build the SD-Card image

From here you can just make the SD-Card image. The output will be written and compressed to `sd-card-rpi-dirty.img.zip`.

```bash
make sd-image
```

### Run Serverspec tests

To test the compressed SD-Card image with Serverspec just run. It will expand the SD-Card image in a Docker container and run the Serverspec tests in `builder/test/` folder against it.

```bash
make test
```

### Run integration tests

Now flash the SD-Card image and boot up a Raspberry Pi. Run the Serverspec integration tests in `builder/test-integration/` folder against your Raspberry Pi.

```bash
BOARD=black-pearl.local make test-integration
```

## License

MIT - see the [LICENSE](./LICENSE) file for details.
