require 'spec_helper'

describe file('/var/local/rpi-swarm_1.2.2.tar.gz') do
  it { should be_file }
end

describe command('docker run --rm -t hypriot/rpi-swarm --version') do
  its(:stdout) { should match /swarm version 1.2.2 \(HEAD\)/ }
  its(:exit_status) { should eq 0 }
end

describe command('docker images hypriot/rpi-swarm') do
  its(:stdout) { should match /hypriot\/rpi-swarm .*latest .*f13b7205f2db / }
  its(:exit_status) { should eq 0 }
end
