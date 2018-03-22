describe file('/boot/config.txt') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  its(:content) { should match /^hdmi_force_hotplug=1/ }
  its(:content) { should match /^enable_uart=0/ }
  its(:content) { should match /^start_x=0/ }
  its(:content) { should match /^disable_camera_led=1/ }
  its(:content) { should match /^gpu_mem=16/ }
end
