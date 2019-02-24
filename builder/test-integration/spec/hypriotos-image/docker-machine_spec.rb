require 'spec_helper'

describe file('/usr/local/bin/docker-machine') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe command('docker-machine --version') do
  its(:stdout) { should match /0.16.1/m }
  its(:exit_status) { should eq 0 }
end

describe file('/etc/bash_completion.d/docker-machine') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end
