require 'spec_helper'

describe file('/boot/bootcode.bin') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/start.elf') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/fixup.dat') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/bcm2708-rpi-b.dtb') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/bcm2708-rpi-b-plus.dtb') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/bcm2708-rpi-cm.dtb') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/bcm2709-rpi-2-b.dtb') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/bcm2710-rpi-3-b.dtb') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/cmdline.txt') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/config.txt') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/boot/overlays') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end
