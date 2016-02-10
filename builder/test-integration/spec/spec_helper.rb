require 'serverspec'
require 'net/ssh'

set :backend, :ssh

host = ENV['BOARD']
unless host
  fail "No BOARD env with the target address given!"
end
port = ENV['PORT']

options = Net::SSH::Config.for(host)

options[:user] ||= 'pirate'
options[:password] ||= 'hypriot'
if port
  options[:port] = port
end

set :host,        options[:host_name] || host
set :ssh_options, options
