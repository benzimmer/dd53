get '/nic/update' do
  basic_auth!
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
