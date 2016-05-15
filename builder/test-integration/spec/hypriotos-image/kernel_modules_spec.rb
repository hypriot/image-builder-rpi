Specinfra::Runner.run_command('modprobe snd_bcm2835')
Specinfra::Runner.run_command('modprobe bcm2835_rng')

describe kernel_module('snd_bcm2835') do
  it { should be_loaded }
end

describe kernel_module('bcm2835_rng') do
  it { should be_loaded }
end
