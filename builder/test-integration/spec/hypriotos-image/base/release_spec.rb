describe file('/etc/hypriot_release') do
  it { should_not be_file }
end

describe file('/etc/os-release') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its(:content) { should contain /ID=debian/ }
  its(:content) { should match /HYPRIOT_OS="HypriotOS\/armhf"/ }
  its(:content) { should match /HYPRIOT_OS_VERSION="v0.8.6"/ }
  its(:content) { should match /HYPRIOT_DEVICE="Raspberry Pi"/ }
  its(:content) { should match /HYPRIOT_IMAGE_VERSION=/ }
end

describe file('/boot/os-release') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its(:content) { should contain /ID=debian/ }
  its(:content) { should match /HYPRIOT_OS="HypriotOS\/armhf"/ }
  its(:content) { should match /HYPRIOT_OS_VERSION="v0.8.6"/ }
  its(:content) { should match /HYPRIOT_DEVICE="Raspberry Pi"/ }
  its(:content) { should match /HYPRIOT_IMAGE_VERSION=/ }
end
