require 'spec_helper'

describe command('docker pull node:10.16.3-slim') do
  its(:exit_status) { should eq 0 }
end

describe command('docker run -t --rm node:10.16.3-slim node --version') do
  its(:stdout) { should match /v10.16.3/ }
#  its(:stderr) { should match /^$/ }
  its(:exit_status) { should eq 0 }
end
