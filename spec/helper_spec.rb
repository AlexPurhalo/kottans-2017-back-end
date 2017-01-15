require 'bundler'

Bundler.require
Bundler.require :test

require 'rspec'
require 'rack/test'

require './app/core'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.color = true
  config.formatter = :documentation
end