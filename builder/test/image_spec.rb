require_relative 'spec_helper'

describe "SD card image" do
  it "exists" do
    image_file = file(image_path)
    expect(image_file).to exist
  end

  context "Partition table" do
    let(:stdout) { run("list-filesystems").stdout }

    it "has two partitions" do
      partitions = stdout.split(/\r?\n/)
      expect(partitions.size).to be 2
    end

    it "has a boot-partition with a vfat filesystem" do
      expect(stdout).to contain('sda1: vfat')
    end

    it "has a root-partition with a ext4 filesystem" do
      expect(stdout).to contain('sda2: ext4')
    end
  end

  context "Binary dpkg" do
    let(:stdout) { run_mounted("file-architecture /usr/bin/dpkg").stdout }

    it "is compiled for ARM architecture" do
      expect(stdout).to contain('arm')
    end
  end

  context "/etc/fstab" do
    let(:stdout) { run_mounted("cat /etc/fstab").stdout }

    it "has a vfat boot entry" do
      expect(stdout).to contain('/dev/mmcblk0p1 /boot vfat')
    end

    it "has a ext4 root entry" do
      expect(stdout).to contain('/dev/mmcblk0p2 / ext4')
    end
  end

  context "Docker Images" do
    let(:stdout) { run_mounted("ls /var/local").stdout }

    it "Consul export file exists" do
      expect(stdout).to contain('rpi-consul_0.6.4.tar.gz')
    end

    it "Docker Swarm export file exists" do
      expect(stdout).to contain('rpi-swarm_1.2.2.tar.gz')
    end
  end

  context "Docker daemon config" do
    let(:stdout) { run_mounted("cat /etc/docker/daemon.json").stdout }

    it "Daemon config is empty" do
      expect(stdout).to contain("{\n}\n\n")
    end
  end

  context "Docker service file" do
    let(:stdout) { run_mounted("cat /etc/systemd/system/docker.service").stdout }

    it "Daemon uses overlay storage driver" do
      expect(stdout).to contain("--storage-driver overlay")
    end
  end
end
