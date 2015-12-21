set :app_file, __FILE__

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'

  set :views, File.join(APP_ROOT, "app", "views")
  set :public_folder, File.join(APP_ROOT, "public")
end

register do
  def auth(enabled)
    condition do
      redirect "/login" unless send("current_user?")
    end
  end

end

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
models = Dir[APP_ROOT.join('app', 'models', '*.rb')]
lib = Dir[APP_ROOT.join('lib', '*.rb')]
(models + lib).each do |file|
  autoload_file(file)
end
