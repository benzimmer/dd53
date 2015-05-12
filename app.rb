require './environment'

require './lib/status'
require './lib/update'

set :username, ENV['USERNAME']
set :password, ENV['PASSWORD']

use Rack::Auth::Basic do |username, password|
  username == settings.username && password == settings.password
end

get '/nic/update' do
  hostnames = params.fetch('hostname', '').split(',')
  ip = params.fetch('myip', request.env['REMOTE_ADDR'])

  return Status.notfqdn if hostnames.empty?
  return Status.numhost if hostnames.size > 1
  return Status.nochg if ip.nil?

  updater = Update.new(hostnames.first, ip)

  begin updater.update
    return Status.good(ip)
  rescue IpChangeError
    return Status.abuse
  rescue IpNotChangedError
    return Status.nochg(ip)
  rescue HostnameNotFoundError
    return Status.nohost
  end
end

