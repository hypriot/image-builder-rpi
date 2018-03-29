require 'spec_helper'

describe package('cloud-init') do
  it { should be_installed }
end

describe file('/boot/user-data') do
  it { should be_file }
  its(:content) { should match /hostname: / }
end

describe file('/boot/meta-data') do
  it { should be_file }
  its(:content) { should match /instance-id: / }
end

describe file('/var/lib/cloud/scripts/per-once/regenerate-machine-id') do
  it { should be_file }
end

describe file('/var/lib/cloud/seed/nocloud-net/user-data') do
  it { should be_linked_to '/boot/user-data' }
end

describe file('/var/lib/cloud/seed/nocloud-net/meta-data') do
  it { should be_linked_to '/boot/meta-data' }
end
