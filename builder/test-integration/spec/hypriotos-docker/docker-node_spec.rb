require 'spec_helper'

describe command('docker pull hypriot/rpi-node:0.12.0') do
  its(:exit_status) { should eq 0 }
end

describe command('docker run -t --rm hypriot/rpi-node:0.12.0 node --version') do
  its(:stdout) { should match /v0.12.0/ }
#  its(:stderr) { should match /^$/ }
  its(:exit_status) { should eq 0 }
end
