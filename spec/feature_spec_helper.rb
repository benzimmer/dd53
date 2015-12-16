require 'spec_helper'
require 'rack/test'

require File.expand_path('../../config/environment', __FILE__)

module RackSpecHelpers
  include Rack::Test::Methods
  attr_accessor :app
end

RSpec.configure do |c|
  c.include RackSpecHelpers, feature: true
  c.before feature: true do
    self.app = Sinatra::Application
  end
end
