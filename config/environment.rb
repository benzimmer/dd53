require 'rubygems'
require 'bundler/setup'

# this will require all the gems not specified to a given group (default)
# and gems specified in your test group
Bundler.require(:default, :development, :test)

Dotenv.load

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

def autoload_file(file)
  filename = File.basename(file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), file
end
