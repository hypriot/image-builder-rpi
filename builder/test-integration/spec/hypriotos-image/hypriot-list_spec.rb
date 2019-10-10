require 'spec_helper'

describe file('/etc/apt/sources.list.d/hypriot.list') do
  it { should_not be_file }
end

describe package('apt-transport-https') do
  it { should be_installed }
end
