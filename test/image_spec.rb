require 'serverspec'
set :backend, :exec

describe "SD-Card Image" do
  let(:image_path) { return '/workspace/sd-card-rpi.img' }

  it "exists" do
    image_file = file(image_path)

    expect(image_file).to exist
  end

  context "Partition table" do
    let(:stdout) { command("guestfish add #{image_path} : run : list-filesystems").stdout }

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
end
