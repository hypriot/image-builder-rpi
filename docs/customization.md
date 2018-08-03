# Image Customization

This repository holds the recipe and files for building an operating system image capable of booting on Raspberry Pi (tested on model `Pi Zero W`).

While you may build locally if you have Docker (tested on Linux), it is recommended that you follow the [workflow](workflow.md).

## Files and Directories

  `builder/files/`: All files in this directory will be copied over to the Raspberry Pi image's root directory.

  `builder/build.sh`: This is the script that does the actual building.

  `builder/chroot-script.sh`: This is the script that is run inside an ARM based virtual machine that emulates the raspberry pi. It installs packages and also generates some configuration files.

  `builder/files/boot/user-data`: This is the configuration file for cloud-init. It holds important customizations such as username creation and hostname configuration.

## Cloud Init Configuration File (`user-data`)

This is one recommended configuration point as it can be modified *before first boot*.

This is the main configuration file for `cloud-init` which is designed to customize cloud servers and provides many useful configuration hooks. Please refer to the [`cloud-init` documentation](https://cloudinit.readthedocs.io/en/0.7.9/) for details.

## Customization Orientation

If you'd like to start scripts every boot, try to customize `builder/files/etc/rc.local` adding commands which will be ran after the rest of the startup process.

Also the web root is at `/var/www/`. You may place web content or applications here. PHP has been enabled by default.

Once you have modified the scripts or files to be included in the distribution, follow the [workflow](workflow.md) into the next step.
