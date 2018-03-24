require_relative 'spec_helper'

describe file('/var/lib/cloud/scripts/per-once/regenerate-machine-id') do
  it { should be_file }
end

describe file('/var/lib/cloud/scripts/per-once/resizefs') do
  it { should be_file }
end

describe file('/var/lib/cloud/seed/nocloud-net/user-data') do
  it { should be_linked_to '/boot/user-data' }
end

describe file('/var/lib/cloud/seed/nocloud-net/meta-data') do
  it { should be_linked_to '/boot/meta-data' }
end
