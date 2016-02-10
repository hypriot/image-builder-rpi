describe file('/etc/hypriot_release') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  its(:content) { should match /profile: hypriot/ }
  its(:content) { should match /build: \d+\-\d+/ }
  its(:content) { should match /commit: [0-9a-f]+/ }
  its(:content) { should match /kernel_build: \d+\-\d+/ }
  its(:content) { should match /kernel_commit: [0-9a-f]+/ }
end
