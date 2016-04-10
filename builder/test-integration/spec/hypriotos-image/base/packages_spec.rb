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

describe package('occi') do
  it { should_not be_installed }
end

describe package('usbutils') do
  it { should be_installed }
end

describe package('firmware-atheros') do
  it { should be_installed }
end

describe package('firmware-brcm80211') do
  it { should be_installed }
end

describe package('firmware-libertas') do
  it { should be_installed }
end

describe package('firmware-ralink') do
  it { should be_installed }
end

describe package('firmware-realtek') do
  it { should be_installed }
end

describe package('wpasupplicant') do
  it { should be_installed }
end

describe package('wireless-tools') do
  it { should be_installed }
end

describe 'for bluetooth-support' do
  describe package('pi-bluetooth') do
    it { should be_installed }
  end

  describe package('bluetooth') do
    it { should be_installed }
  end
end

