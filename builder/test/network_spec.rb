require_relative 'spec_helper'

describe "Network" do
  context "IPv4 netfilter" do
    let(:stdout) { run_mounted("cat /etc/sysctl.conf").stdout }

    it "has ip_conntrack_tcp_be_liberal" do
      expect(stdout).to contain('net.ipv4.netfilter.ip_conntrack_tcp_be_liberal = 1')
    end
  end
end
