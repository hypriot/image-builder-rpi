require 'serverspec'
set :backend, :exec

describe "/etc/fstab" do
  let(:image_path) { return 'sd-card-rpi.img' }
  let(:stdout) { command("guestfish add #{image_path} : run : mount /dev/sda2 / : cat /etc/fstab").stdout }

  it "has a vfat boot entry" do
    expect(stdout).to contain('/dev/mmcblk0p1	/boot	vfat')
  end

  it "has a ext4 root entry" do
    expect(stdout).to contain('/dev/mmcblk0p2	/	  	ext4')
  end
end
