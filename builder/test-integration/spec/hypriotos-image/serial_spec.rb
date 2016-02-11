require 'spec_helper'

describe file('/usr/local/bin/rpi-serial-console') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end
