require_relative 'spec_helper'

describe "cloud-init" do
  context "/var/lib/cloud/scripts/per-once" do
    let(:stdout) { run_mounted("ls -1 /var/lib/cloud/scripts/per-once").stdout }

    print "XXX3 stdout /var/lib/cloud/scripts/per-once"
    print stdout
    
    # it "has a regenerate-machine-id script" do
    #   expect(stdout).to contain('regenerate-machine-id')
    # end
    # 
    # it "has a resize2fs script" do
    #   expect(stdout).to contain('resize2fs')
    # end
  end

  context "/var/lib/cloud/seed/nocloud-net" do
    let(:stdout) { run_mounted("ls -l /var/lib/cloud/seed/nocloud-net").stdout }

    print "XXX4 stdout /var/lib/cloud/seed/nocloud-net"
    print stdout

    # it "user-data is linked to /boot/user-data" do
    #   expect(stdout).to contain('user-data -> /boot/user-data')
    # end
    # 
    # it "meta-data is linked to /boot/meta-data" do
    #   expect(stdout).to contain('meta-data -> /boot/meta-data')
    # end
  end
end
