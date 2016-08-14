require 'spec_helper'

describe package('device-init') do
  it { should be_installed }
end

describe command('dpkg -l device-init') do
  its(:stdout) { should match /ii  device-init/ }
  its(:stdout) { should match /0.1.8/ }
  its(:exit_status) { should eq 0 }
end

describe file('/boot/device-init.yaml') do
  it { should be_file }
  its(:content) { should match /hostname: / }
end

describe file('/usr/local/bin/device-init') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

# describe command('device-init --version') do
#   its(:stdout) { should match /0.0.14/m }
# #  its(:stderr) { should match /^$/ }
#   its(:exit_status) { should eq 0 }
# end
