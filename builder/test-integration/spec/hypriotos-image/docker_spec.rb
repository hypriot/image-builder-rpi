require 'spec_helper'

describe package('docker-hypriot') do
  it { should be_installed }
end

describe command('dpkg -l docker-hypriot') do
  its(:stdout) { should match /ii  docker-hypriot/ }
  its(:stdout) { should match /1.9.0-2/ }
  its(:exit_status) { should eq 0 }
end

describe file('/usr/bin/docker') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/usr/lib/docker/dockerinit') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/etc/init.d/docker') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/etc/default/docker') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  its(:content) { should match /--storage-driver=overlay/ }
end

describe file('/var/lib/docker') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'root' }
end

describe file('/var/lib/docker/overlay') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/var/lib/docker/repositories-overlay') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'root' }
end

describe file('/etc/bash_completion.d/docker') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_file }
end

describe file('/usr/local/bin/docker-cleanup-volumes') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe command('docker -v') do
  its(:stdout) { should match /Docker version 1.9.0, build/ }
  its(:exit_status) { should eq 0 }
end

describe command('docker version') do
  its(:stdout) { should match /Client:. Version:      1.9.0. API version:  1.21/m }
  its(:stdout) { should match /Server:. Version:      1.9.0. API version:  1.21/m }
  its(:exit_status) { should eq 0 }
end

describe command('docker info') do
  its(:stdout) { should match /Storage Driver: overlay/ }
  its(:exit_status) { should eq 0 }
end

describe interface('lo') do
  it { should exist }
end

describe interface('docker0') do
  it { should exist }
end

describe service('docker') do
  it { should be_enabled }
  it { should be_running }
end

describe command('grep docker /var/log/syslog') do
  its(:stdout) { should match /Daemon has completed initialization/ }
  its(:exit_status) { should eq 0 }
end
