get '/login' do
  hide_navigation!
  page_title 'Login'

  haml :login
end

post '/login' do
  user = User.find_by(email: params[:email])
  if user.try(:authenticate, params[:password])
    session[:user_id] = user.id

    redirect to('/')
  else
    redirect to('/login')
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect to('/login')
end
