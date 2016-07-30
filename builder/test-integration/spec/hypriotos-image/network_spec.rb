require 'spec_helper'

describe file('/proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_be_liberal') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should contain '1' }
end
