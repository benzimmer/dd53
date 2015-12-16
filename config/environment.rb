require 'rubygems'
require 'bundler/setup'

# this will require all the gems not specified to a given group (default)
# and gems specified in your test group
Bundler.require(:default, :development, :test)

Dotenv.load

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

def autoload_file(file)
  filename = File.basename(file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), file
end

# Set up the database and models
models = Dir[APP_ROOT.join('app', 'models', '*.rb')]
lib = Dir[APP_ROOT.join('lib', '*.rb')]
(models + lib).each do |file|
  autoload_file(file)
end
