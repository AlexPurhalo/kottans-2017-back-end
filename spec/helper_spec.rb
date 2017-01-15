ENV['RACK_ENV'] = 'test'

require 'bundler'

Bundler.require
Bundler.require :test

require 'rspec'
require 'rack/test'
require 'database_cleaner'

DB = Sequel.connect('sqlite://db/test.db')
DatabaseCleaner[:sequel, { :connection => DB } ]

require './app/core'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.color = true
  config.formatter = :documentation

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end