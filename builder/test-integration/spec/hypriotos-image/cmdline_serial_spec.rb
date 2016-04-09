describe file('/boot/cmdline.txt') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  its(:content) { should match /console=tty1/ }
  its(:content) { should match /console=ttyAMA0,115200/ }
  its(:content) { should match /kgdboc=ttyAMA0,115200/ }
end
