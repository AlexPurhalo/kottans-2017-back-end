require 'rack'
require 'rubygems'
require 'bundler/setup'
require 'grape'
require 'sequel'
require 'rest-client'
require 'rack/cors'

require 'dotenv/load'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/database.db')

require './app/core'

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
             :headers => :any,
             :methods => [:get, :post, :delete, :put, :options]
  end
end


use Rack::Config do |env|
  env['api.tilt.root'] = 'app/views'
end

Rabl.configure do |config|
  config.include_json_root = false
  config.include_child_root = false
end

run App