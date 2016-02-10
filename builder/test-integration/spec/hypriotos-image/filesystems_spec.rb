Specinfra::Runner.run_command('modprobe btrfs')
describe kernel_module('btrfs') do
  it { should be_loaded }
end

Specinfra::Runner.run_command('modprobe overlay')
describe kernel_module('overlay') do
  it { should be_loaded }
end
