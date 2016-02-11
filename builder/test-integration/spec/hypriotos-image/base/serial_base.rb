describe command('ps -ax') do
  its(:stdout) { should match /getty -L ttyAMA0 115200 vt100/ }
end

describe file('/etc/inittab') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  its(:content) { should match /^T0:23:respawn:\/sbin\/getty -L ttyAMA0 115200 vt100/ }
end

describe file('/usr/bin/rpi-serial-console') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end
