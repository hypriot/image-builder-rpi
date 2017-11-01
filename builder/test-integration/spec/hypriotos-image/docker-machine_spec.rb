require 'spec_helper'

describe package('docker-machine') do
  it { should_not be_installed }
end

describe file('/usr/local/bin/docker-machine') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe command('docker-machine --version') do
  its(:stdout) { should match /0.13.0/m }
  its(:exit_status) { should eq 0 }
end
