require './lib/status'
require './lib/update'
require './lib/host'

set :username, ENV['AUTH_USERNAME']
set :password, ENV['AUTH_PASSWORD']

use Rack::Auth::Basic do |username, password|
  username == settings.username && password == settings.password
end

get '/' do
  @page_title = 'Overview'

  @hosts = Host.all

  haml :index
end

