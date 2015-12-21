require ::File.expand_path('../config/environment',  __FILE__)
require ::File.expand_path('../config/application',  __FILE__)

run Sinatra::Application

$stdout.sync = true
