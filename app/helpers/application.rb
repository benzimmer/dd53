helpers do

  def basic_auth!
    auth ||=  Rack::Auth::Basic::Request.new(request.env)
    if auth.provided? && auth.basic? && auth.credentials
      user = User.find_by(email: auth.credentials.first)
      if user && user.authenticate(auth.credentials.last)
        return
      end
    end
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def page_title(string)
    @page_title = string
  end

  def hide_navigation!
    @hide_navigation = true
  end

  def hide_navigation?
    @hide_navigation
  end

end
