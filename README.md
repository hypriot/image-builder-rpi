
# Public Lab Pi Camera Kit

The Public Lab Pi Camera Kit includes an operating system which is built upon the efforts of many people.

The build scripts have been forked from the Hypriot project.

## Build instructions

**Automatic build**: For the purposes of facilitating quick development of this image, we've setup [automatic builds](https://jenkins.laboratoriopublico.org/job/Raspberry%20Kit%20Image/) on git commits to **master** branch. Downlod the [latest development build](https://jenkins.laboratoriopublico.org/job/Raspberry%20Kit%20Image/ws/hypriotos-rpi-dirty.img.zip).

Pre-requisites: You'll need to have Docker installed.

```
make sd-card
```

This will create an image called `hypriotos-rpi-dirty.img.zip`.

## Flash instructions

You'll need the [Hypriot flash tool](https://github.com/hypriot/flash)

```
git clone https://github.com/hypriot/flash
cd flash
./flash ~/location_of/hypriotos-rpi-dirty.img.zip
```

## Usage instructions (tested on Pi W Zero)

Place the flashed microSD card into your Pi device, power it up and give it a minute or two to start the embedded access point "**00-PiCamera**", with password **publiclab**.

Once you are connected to this wifi network, the Pi has hostname `pi` with IP address `172.24.1.1` and can be reached with from the `pi.local` or `pi.localdomain` address (either avahi or dns).

By default a user called **publiclab** is created with same password.

Features:
  - ssh service on port 22
  - Lighthttp on port 80
  - Flash tool can customize image at **flash time**

Desired in the short term:
  - Camera is pre-enabled
  - USB OTG is also enabled (with IP address `192.168.7.2`)

Check planning issue [5](https://github.com/publiclab/image-builder-rpi/issues/5) for other plans.

We've disabled for build performance:
  - Docker tools
