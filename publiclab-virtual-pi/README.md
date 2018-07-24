# "virtual-pi"

## Project scope

Development of a reproducible “build” process for converting official Raspbian SD card
images to an image which, when flashed to an SD card and used with a Raspberry Pi Zero W,
can produce a WiFi hotspot for easy use. Optional follow-up goals (only if time remains) in this
contract include additionally simultaneously connecting the Raspberry Pi to another WiFi
network for internet access during use, and a “captive portal” setup to direct users to the correct
URL to view images.

## Project parts

 - [x] Research reproducible build method
 - [x] Translate loose scripts into build
 - [x] Setup automated build process
 - [x] Make sure built image is equivalent to original ** original 'lite' image
 - [x] Convert hostapd configuration.

## Secondary feature goals

 - [ ] Simultaneous client wifi
 - [ ] Captive portal to images (and wifi config)

### Some subgoals

 - [ ] Preinstall all desired packages
 - [ ] Analyze loose scripts to avoid bad practices
 - [ ] Place and manage configuration files
 - [ ] Document process reusably

## Loose Scripts referenced from current practice

Following are some of the scripts used in current manual image building process.

https://github.com/silvanmelchior/RPi_Cam_Web_Interface/blob/master/RPi_Cam_Web_Interface_Installer.sh
https://raw.githubusercontent.com/billz/raspap-webgui/master/installers/raspbian.sh
https://raw.githubusercontent.com/billz/raspap-webgui/master/installers/common.sh
https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh

Some configuration templates have been put in `templates/` directory.
