require 'spec_helper'

describe file('/var/local/rpi-consul_0.6.4.tar.gz') do
  it { should be_file }
end

describe command('docker run --rm -t hypriot/rpi-consul --version') do
  its(:stdout) { should match /Consul v0\.6\.4/ }
  its(:exit_status) { should eq 0 }
end

describe command('docker images hypriot/rpi-consul') do
  its(:stdout) { should match /hypriot\/rpi-consul .*latest .*879ac05d5353 / }
  its(:exit_status) { should eq 0 }
end
