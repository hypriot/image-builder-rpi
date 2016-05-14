require 'spec_helper'

describe command('uname -r') do
  its(:stdout) { should match /4.4.10(-v7)?+/ }
  its(:exit_status) { should eq 0 }
end

describe file('/lib/modules/3.18.7+') do
  it { should_not be_directory }
end

describe file('/lib/modules/3.18.7-v7+') do
  it { should_not be_directory }
end

describe file('/lib/modules/3.18.10+') do
  it { should_not be_directory }
end

describe file('/lib/modules/3.18.10-v7+') do
  it { should_not be_directory }
end

describe file('/lib/modules/4.1.6+') do
  it { should_not be_directory }
end

describe file('/lib/modules/4.1.6-v7+') do
  it { should_not be_directory }
end

describe file('/lib/modules/4.1.7+') do
  it { should_not be_directory }
end

describe file('/lib/modules/4.1.7-v7+') do
  it { should_not be_directory }
end

describe file('/lib/modules/4.1.8+') do
  it { should_not be_directory }
end

describe file('/lib/modules/4.1.8-v7+') do
  it { should_not be_directory }
end

describe file('/lib/modules/4.1.20+') do
  it { should_not be_directory }
end

describe file('/lib/modules/4.1.20-v7+') do
  it { should_not be_directory }
end

# with installed kernel headers
describe file('/lib/modules/4.4.10-hypriotos+/build') do
  it { should be_symlink }
#  it { should be_linked_to '/usr/src/linux-headers-4.4.10-hypriotos+' }
end

describe file('/lib/modules/4.4.10-hypriotos-v7+/build') do
  it { should be_symlink }
#  it { should be_linked_to '/usr/src/linux-headers-4.4.10-hypriotos-v7+' }
end

describe file('/usr/src/linux-headers-4.4.10-hypriotos-v7+') do
  it { should be_directory }
end

describe file('/usr/src/linux-headers-4.4.10-hypriotos+') do
  it { should be_directory }
end
