# image-builder-rpi

[![Join the chat at https://gitter.im/hypriot/talk](https://badges.gitter.im/hypriot/talk.svg)](https://gitter.im/hypriot/talk?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://circleci.com/gh/hypriot/image-builder-rpi.svg?style=svg)](https://circleci.com/gh/hypriot/image-builder-rpi)
[![Latest Release](https://img.shields.io/github/downloads/hypriot/image-builder-rpi/v1.9.0/total.svg)](https://github.com/hypriot/image-builder-rpi/releases/tag/v1.9.0)
[![All Releases](https://img.shields.io/github/downloads/hypriot/image-builder-rpi/total.svg)](https://github.com/hypriot/image-builder-rpi/releases)

This repo builds the SD card image with HypriotOS for the Raspberry Pi 1, 2, 3
and Zero. You can find released versions of the SD card image here in the GitHub
releases page. To build this SD card image we have to

* take the files for the root filesystem from [`os-rootfs`](https://github.com/hypriot/os-rootfs)
* take the empty raw filesystem from [`image-builder-raw`](https://github.com/hypriot/image-builder-raw) with the two partitions
* add Hypriot's Debian repos
* install the Raspberry Pi kernel from [`rpi-kernel`](https://github.com/hypriot/rpi-kernel)
* install Docker tools Docker Engine, Docker Compose and Docker Machine

Here is an example how all the GitHub repos play together:

![Architecture](http://blog.hypriot.com/images/hypriotos-xxx/hypriotos_buildpipeline.jpg)

## Contributing

You can contribute to this repo by forking it and sending us pull requests.
Feedback is always welcome!

You can build the SD card image locally with Vagrant.

### Setting up build environment

Make sure you have [vagrant](https://docs.vagrantup.com/v2/installation/) installed.
Then run the following command to create the Vagrant box and use the Vagrant Docker
daemon. The Vagrant box is needed to run guestfish inside.
Use `export VAGRANT_DEFAULT_PROVIDER=virtualbox` to strictly create a VirtualBox VM.

Start vagrant box

```bash
vagrant up
```

Export docker host

```bash
export DOCKER_HOST=tcp://127.0.0.1:2375
```

Check you are using docker from inside vagrant

```bash
docker info | grep 'Operating System'
Operating System: Ubuntu 16.04.3 LTS
```

### Build the SD card image

From here you can just make the SD card image. The output will be written and
compressed to `hypriotos-rpi-dirty.img.zip`.

```bash
make sd-image
```

### Run Serverspec tests

To test the compressed SD card image with [Serverspec](http://serverspec.org)
just run the following command. It will expand the SD card image in a Docker
container and run the Serverspec tests in `builder/test/` folder against it.

```bash
make test
```

### Run integration tests

Now flash the SD card image and boot up a Raspberry Pi. Run the [Serverspec](http://serverspec.org) integration tests in `builder/test-integration/`
folder against your Raspberry Pi. Set the environment variable `BOARD` to the
IP address or host name of your running Raspberry Pi.

```bash
flash hypriotos-rpi-dirty.img.zip
BOARD=black-pearl.local make test-integration
```

This test works with any Docker Machine, so you do not need to create the
Vagrant box.

## Deployment

For maintainers of this project you can release a new version and deploy the
SD card image to GitHub releases with

```bash
TAG=v0.0.1 make tag
```

After that open the GitHub release of this version and fill it with relevant
changes and links to resolved issues.

## Buy us a beer!

This FLOSS software is funded by donations only. Please support us to maintain and further improve it!

<a href="https://liberapay.com/Hypriot/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>




## License

MIT - see the [LICENSE](./LICENSE) file for details.
