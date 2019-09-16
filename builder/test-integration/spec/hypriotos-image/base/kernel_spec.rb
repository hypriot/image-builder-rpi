require 'spec_helper'

describe command('uname -r') do
  its(:stdout) { should match /4.19.66(-v7)?+/ }
  its(:exit_status) { should eq 0 }
end

describe file('/lib/modules/4.19.66+/kernel') do
  it { should be_directory }
end

describe file('/lib/modules/4.19.66-v7+/kernel') do
  it { should be_directory }
end
