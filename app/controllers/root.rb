get '/', auth: true do
  @page_title = 'Overview'

  @hosts = Host.all

  haml :index
end

