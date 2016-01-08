# image-builder-rpi

This is work in progress and not yet finished.

# Setting up Docker
A `vagrant up` in the root folder of this repository sets up a Ubuntu Trusty VM with the latest Docker installed.

To use this Docker instance from your host one can use `docker-machine`.  
To set it up with your Vagrant VM execute the following command:
```
docker-machine create -d generic \
  --generic-ssh-user vagrant \
  --generic-ssh-key .vagrant/machines/default/virtualbox/private_key \
  --generic-ip-address 127.0.0.1 \
  --generic-ssh-port 2222 \
  image-builder
```

From here just use `make` to make a new SD-Card image:

`make sd-image`
