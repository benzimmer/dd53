# new
get '/hosts/new', auth: true do
  @page_title = 'Create new host'

  haml :new_host
end

# create
post '/hosts', auth: true do
  host_params = params[:host].merge({ip: request.env['REMOTE_ADDR']})
  if  Host.create(host_params)
    redirect to('/')
  else
    haml :new_host
  end
end
