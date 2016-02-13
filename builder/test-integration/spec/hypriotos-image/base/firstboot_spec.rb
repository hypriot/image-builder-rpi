require 'spec_helper'

describe file('/etc/hypriot-firstboot_not_to_be_run') do
  it { should be_file }
end
