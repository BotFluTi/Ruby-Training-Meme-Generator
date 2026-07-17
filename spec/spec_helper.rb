# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'json'
require 'rack/test'
require 'rspec'
require './api'

module ApiSpecHelper
  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include ApiSpecHelper
end
