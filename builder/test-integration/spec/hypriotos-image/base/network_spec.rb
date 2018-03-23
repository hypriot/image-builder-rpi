
describe file('/etc/network/interfaces.d/eth0') do
  it { should_not be_file }
end
