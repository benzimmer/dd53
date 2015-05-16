require './environment'

require './lib/status'
require './lib/update'

require './models/log'
require './models/pagination'

set :username, ENV['USERNAME']
set :password, ENV['PASSWORD']

use Rack::Auth::Basic do |username, password|
  username == settings.username && password == settings.password
end

get '/' do
  @pagination = Pagination.new(Log, page: params[:page], limit: 10)
  @logs = @pagination.entries

  haml :index
end

get '/nic/update' do
  hostnames = params.fetch('hostname', '').split(',')
  ip = params.fetch('myip', request.env['REMOTE_ADDR'])

  updater = Update.new(hostnames, ip)
  updater.update

  Log.create(data: {
    ip: ip,
    hostname: hostnames.join(','),
    user_agent: request.user_agent,
    status: updater.status,
  })

  return updater.status
end

