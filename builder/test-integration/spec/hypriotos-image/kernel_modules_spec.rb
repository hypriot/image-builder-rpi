Specinfra::Runner.run_command('modprobe snd_bcm2835')

describe kernel_module('snd_bcm2835') do
  it { should be_loaded }
end
