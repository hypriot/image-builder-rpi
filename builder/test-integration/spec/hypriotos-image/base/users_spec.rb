describe user('root') do
  it { should exist }
  it { should have_home_directory '/root' }
  it { should have_login_shell '/bin/bash' }
end

describe group('docker') do
  it { should exist }
end

describe user('pi') do
  it { should exist }
  it { should have_home_directory '/home/pi' }
  it { should have_login_shell '/bin/bash' }
  it { should belong_to_group 'docker' }
end

describe file('/etc/sudoers') do
  it { should be_file }
  it { should be_mode 440 }
  it { should be_owned_by 'root' }
end

describe file('/etc/sudoers.d') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/etc/sudoers.d/user-pi') do
  it { should be_file }
  it { should be_mode 440 }
  it { should be_owned_by 'root' }
  its(:content) { should match /pi ALL=NOPASSWD: ALL/ }
end

describe file('/root/.bashrc') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end
describe file('/root/.bash_prompt') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe file('/home/pi/.bashrc') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'pi' }
end
describe file('/home/pi/.bash_prompt') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'pi' }
end
