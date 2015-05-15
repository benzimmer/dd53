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

  updater = Update.new(hostnames, ip)
  updater.update


  return updater.status
end

