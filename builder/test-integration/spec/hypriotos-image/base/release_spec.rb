describe file('/etc/hypriot_release') do
  it { should_not be_file }
end

describe file('/etc/os-release') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its(:content) { should match /HYPRIOT_OS="HypriotOS\/armhf"/ }
  its(:content) { should match /HYPRIOT_TAG="v0.6.1"/ }
end
