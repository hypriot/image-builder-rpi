# only test for built-in bluetooth support if we are on the Raspberry Pi 3
cpu_info = `cat /proc/cpu_info`

if cpu_info.include?('a02082') or cpu_info.include?('a22082')
  describe command('hciconfig') do
    its(:stdout) { should contain /hci0/ }
    its(:stdout) { should contain /UP RUNNING/ }
  end
end
