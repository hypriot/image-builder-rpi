require 'spec_helper'

describe command('docker images hypriot/rpi-swarm') do
  its(:stdout) { should match /hypriot\/rpi-swarm .*latest .*039c550f6208 / }
  its(:exit_status) { should eq 0 }
end

describe file('/var/hypriot/swarm.tar.gz') do
  it { should_not be_file }
end

describe command('docker run --rm -t hypriot/rpi-swarm --version') do
  its(:stdout) { should match /swarm version 1.0.0 \(HEAD\)/ }
  its(:exit_status) { should eq 0 }
end
