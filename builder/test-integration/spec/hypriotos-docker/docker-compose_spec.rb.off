require 'spec_helper'

describe command('rm -rf rpi-node-haproxy-example && git clone https://github.com/hypriot/rpi-node-haproxy-example') do
  its(:exit_status) { should eq 0 }
end

describe command('cd rpi-node-haproxy-example && docker-compose up -d') do
  its(:exit_status) { should eq 0 }
end

describe command('cd rpi-node-haproxy-example && docker-compose ps') do
  its(:stdout) { should match /rpinodehaproxyexample_haproxy_1   bash \/haproxy-start   Up/ }
  its(:stdout) { should match /rpinodehaproxyexample_weba_1      node index.js         Up/ }
  its(:stdout) { should match /rpinodehaproxyexample_webb_1      node index.js         Up/ }
  its(:stdout) { should match /rpinodehaproxyexample_webc_1      node index.js         Up/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl http://localhost') do
  its(:stdout) { should match /Hello from Node.js container/ }
  its(:exit_status) { should eq 0 }
end

describe command('cd rpi-node-haproxy-example && docker-compose kill') do
  its(:exit_status) { should eq 0 }
end

describe command('cd rpi-node-haproxy-example && docker-compose ps') do
  its(:stdout) { should match /rpinodehaproxyexample_haproxy_1   bash \/haproxy-start   Exit 137/ }
  its(:stdout) { should match /rpinodehaproxyexample_weba_1      node index.js         Exit 137/ }
  its(:stdout) { should match /rpinodehaproxyexample_webb_1      node index.js         Exit 137/ }
  its(:stdout) { should match /rpinodehaproxyexample_webc_1      node index.js         Exit 137/ }
  its(:exit_status) { should eq 0 }
end
