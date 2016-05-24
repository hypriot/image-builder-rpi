require 'spec_helper'

describe package('docker-machine') do
  it { should be_installed }
end

describe command('dpkg -l docker-machine') do
  its(:stdout) { should match /ii  docker-machine/ }
  its(:stdout) { should match /0.7.0-26/ }
  its(:exit_status) { should eq 0 }
end

describe file('/usr/local/bin/docker-machine') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe command('docker-machine --version') do
  its(:stdout) { should match /0.7.0/m }
  its(:exit_status) { should eq 0 }
end
