describe file('/boot/cmdline.txt') do
  it { should be_file }
  its(:content) { should match /console=tty1/ }
  its(:content) { should match /rootfstype=ext4/ }
  its(:content) { should match /cgroup-enable=memory/ }
  its(:content) { should match /swapaccount=1/ }
end
