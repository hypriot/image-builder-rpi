describe package('curl') do
  it { should be_installed }
end

describe package('wget') do
  it { should be_installed }
end

describe package('bash-completion') do
  it { should be_installed }
end

describe package('htop') do
  it { should be_installed }
end

describe package('fake-hwclock') do
  it { should be_installed }
end

describe package('occi') do
  it { should be_installed }
end

describe package('usbutils') do
  it { should be_installed }
end

describe package('firmware-ralink') do
  it { should be_installed }
end

describe package('firmware-realtek') do
  it { should be_installed }
end
