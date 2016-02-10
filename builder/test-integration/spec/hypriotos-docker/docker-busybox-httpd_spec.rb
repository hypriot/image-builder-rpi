require 'spec_helper'

describe command('docker pull hypriot/rpi-busybox-httpd:0.1.0') do
  its(:exit_status) { should eq 0 }
end

describe command('docker run -t --rm hypriot/rpi-busybox-httpd:0.1.0 busybox') do
  its(:stdout) { should match /BusyBox v1.20.2/ }
  its(:exit_status) { should eq 0 }
end

describe command('docker run -t --rm hypriot/rpi-busybox-httpd:0.1.0 busybox httpd') do
  its(:exit_status) { should eq 0 }
end
