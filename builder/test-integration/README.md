# HypriotOS serverspec tests

To test the SD card image for the Raspberry Pi use this [Serverspec](http://serverspec.org) tests. See the [Serverspec Docs](http://serverspec.org/resource_types.html) for more details what you can test with it.

## Preparation

1. Flash the SD card image
2. Put the SD card into your Raspberry Pi
3. Power on the Raspberry Pi
4. Retrieve the host name or IP address to reach the Pi

## Install Serverspec

You need ruby and bundle installed. Then you can install the dependencies locally with

```bash
bundle install
```

## Run tests

Set the `BOARD` environment variable to the host name or
IP address of your Pi. The user name for the test is `root`.

### Remove previous fingerpint

You normally have to remove the fingerprint of a previously tested Hypriot Pi.
Use the hostname or the IP address of your Raspberry Pi.

```bash
ssh-keygen -R black-pearl.local
```

### Run basic SD image tests

Now run the basic SD card image tests. This tests if docker is up and running and the image has everything as we expect it.

```bash
BOARD=black-pearl.local bin/rspec spec/hypriotos-image
```

### Run full docker test

Now run a full docker test. This does a full cycle with `docker pull` and `docker run` to see that everything works fine.

```
BOARD=black-pearl.local bin/rspec spec/hypriotos-docker
```
