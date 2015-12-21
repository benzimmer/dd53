get '/updates', auth: true do
  @page_title = 'Updates'

  @pagination = Pagination.new(Log, page: params[:page], limit: 10)
  @logs = @pagination.entries

  haml :updates
end
