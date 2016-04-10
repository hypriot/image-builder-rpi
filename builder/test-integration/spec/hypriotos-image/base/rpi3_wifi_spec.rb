# only test for built-in bluetooth support if we are on the Raspberry Pi 3
cpu_info = command('cat /proc/cpuinfo').stdout

if cpu_info.include?('a02082') or cpu_info.include?('a22082')
  describe "RPi 3: built-in wifi works" do
    describe command('ifconfig -a') do
      its(:stdout) { should contain /wlan0/ }
    end

    describe command('ethtool -i wlan0') do
      its(:stdout) { should contain /driver: brcmfmac/ }
      its(:stdout) { should contain /version: 7.45.41.23/ }
      its(:stdout) { should contain /firmware-version: 01-cc4eda9c/ }
    end
  end
end
