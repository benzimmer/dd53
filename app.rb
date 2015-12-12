require './environment'

require './lib/status'
require './lib/update'
require './lib/host'

require './models/log'
require './models/pagination'

set :username, ENV['AUTH_USERNAME']
set :password, ENV['AUTH_PASSWORD']

use Rack::Auth::Basic do |username, password|
  username == settings.username && password == settings.password
end

get '/' do
  @hosts = Host.all

  haml :index
end

get '/updates' do
  @pagination = Pagination.new(Log, page: params[:page], limit: 10)
  @logs = @pagination.entries

  haml :updates
end

get '/hosts/new' do

  haml :new_host
end

post '/hosts' do
  host_params = params[:host].merge({ip: request.env['REMOTE_ADDR']})
  if  Host.create(host_params)
    redirect to('/')
  else
    haml :new_host
  end
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

