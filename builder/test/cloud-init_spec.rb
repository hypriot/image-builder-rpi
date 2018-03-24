require_relative 'spec_helper'

describe file('/usr/lib/cloud/scripts/per-once/regenerate-machine-id') do		
  it { should be_file }		
end

describe file('/usr/lib/cloud/scripts/per-once/resizefs') do		
  it { should be_file }		
end

describe file('/boot/user-data') do
  it { should be_file }
  its(:content) { should match /hostname: / }
end

describe file('/boot/meta-data') do
  it { should be_file }
end
