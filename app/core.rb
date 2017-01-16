RACK_ENV = (ENV['RACK_ENV'] || 'development').to_sym

require 'rubygems'
require 'bundler'
Bundler.require

app_base = "#{File.dirname(File.expand_path(__FILE__))}/.."
Dir.glob("#{app_base}/app/models/*.rb").each { |i| require i }
Dir.glob("#{app_base}/app/api/*.rb").each { |i| require i }

class App < Grape::API
  format :json
  formatter :json, Grape::Formatter::Rabl

  mount Users
  mount Sessions
end