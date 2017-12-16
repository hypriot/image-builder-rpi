# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 2376, host: 2376, auto_correct: true
  config.vm.synced_folder ".", "#{`pwd`.chomp}"

  config.vm.provider "vmware_fusion" do |v|
    # Customize the amount of memory on the VM:
    v.memory = "2048"
  end

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "2048"
    vb.cpus = 4
  end

  config.vm.provision "shell", inline: <<-SHELL
     sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
     echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
     sudo apt-get update
     sudo apt-get install -y linux-image-extra-$(uname -r)
     sudo mkdir -p /etc/systemd/system/docker.service.d
     # https://docs.docker.com/engine/admin/#troubleshoot-conflicts-between-the-daemonjson-and-startup-scripts
 echo "
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd" > /etc/systemd/system/docker.service.d/docker.conf
     sudo apt-get install -y docker.io
 echo '
 {
 "hosts": ["tcp://0.0.0.0:2376"]
 }
 ' > /etc/docker/daemon.json
     sudo systemctl daemon-reload
     sudo systemctl enable docker
     sudo systemctl start docker
  SHELL
end
