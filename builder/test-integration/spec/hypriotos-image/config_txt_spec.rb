describe file('/boot/config.txt') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  its(:content) { should match /^hdmi_force_hotplug=1/ }
  its(:content) { should match /^enable_uart=1/ }
end
