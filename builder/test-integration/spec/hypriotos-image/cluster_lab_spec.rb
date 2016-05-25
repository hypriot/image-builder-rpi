require 'spec_helper'

describe package('hypriot-cluster-lab') do
  it { should be_installed }
end

describe command('dpkg -l hypriot-cluster-lab') do
  its(:stdout) { should match /ii  hypriot-cluster-lab/ }
  its(:stdout) { should match /0.2.12/ }
  its(:exit_status) { should eq 0 }
end

describe file('/usr/local/bin/cluster-lab') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end
