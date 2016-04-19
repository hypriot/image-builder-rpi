require 'spec_helper'

describe file('/etc/udev/rules.d/99-com.rules') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe file('/etc/udev/rules.d/75-persistent-net-generator.rules') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end
