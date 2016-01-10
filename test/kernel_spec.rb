require 'serverspec'
set :backend, :exec

describe "Kernel" do
  let(:image_path) { return 'sd-card-rpi.img' }

  context "uname" do
    let(:stdout) { command("guestfish add #{image_path} : run : mount /dev/sda2 / : uname -a").stdout }

    it "returns the correct kernel" do
      expect(stdout).to contain('4.1.12-hypriotos')
    end
end
