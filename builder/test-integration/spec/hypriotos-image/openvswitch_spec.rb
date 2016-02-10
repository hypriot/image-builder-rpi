Specinfra::Runner.run_command('modprobe openvswitch')
Specinfra::Runner.run_command('modprobe vxlan')
Specinfra::Runner.run_command('modprobe gre')

describe kernel_module('openvswitch') do
  it { should be_loaded }
end

describe kernel_module('vxlan') do
  it { should be_loaded }
end

describe kernel_module('gre') do
  it { should be_loaded }
end
