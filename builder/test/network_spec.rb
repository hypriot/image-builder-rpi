require_relative 'spec_helper'

describe "Network" do
  context "IPv4 netfilter" do
    let(:stdout) { run_mounted("ls -1 /proc/sys/net/ipv4/netfilter").stdout }

    it "has ip_conntrack_tcp_max_retrans" do
      expect(stdout).to contain('ip_conntrack_tcp_max_retrans')
    end

    it "has ip_conntrack_tcp_be_liberal" do
      expect(stdout).to contain('ip_conntrack_tcp_be_liberal')
    end
  end
end
