require 'spec_helper'

describe package('docker-compose') do
  it { should be_installed }
end

describe command('dpkg -l docker-compose') do
  its(:stdout) { should match /ii  docker-compose/ }
  its(:stdout) { should match /1.7.1-40/ }
  its(:exit_status) { should eq 0 }
end

describe file('/usr/local/bin/docker-compose') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe command('docker-compose --version') do
  its(:stdout) { should match /1.7.1/m }
  its(:exit_status) { should eq 0 }
end
