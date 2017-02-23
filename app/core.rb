RACK_ENV = (ENV['RACK_ENV'] || 'development').to_sym

require 'rubygems'
require 'bundler'
Bundler.require

app_base = "#{File.dirname(File.expand_path(__FILE__))}/.."
Dir.glob("#{app_base}/app/models/*.rb").each { |i| require i }
Dir.glob("#{app_base}/app/api/*.rb").each { |i| require i }
Dir.glob("#{app_base}/app/helpers/*.rb").each { |i| require i }
Dir.glob("#{app_base}/app/services/*.rb").each { |i| require i }

class App < Grape::API
  format :json
  formatter :json, Grape::Formatter::Rabl

  # Validation Services
  mount ValidationService
  mount AuthErrorsService
  mount PostCreatingErrorsService
  mount PostsReadingErrorsService
  mount PostPreferencesErrorsService

  # Data Generation Services
  mount CreatePostService
  mount ReadPostsService
  mount AddPreferenceService

  # Helpers
  helpers Validation

  # API
  mount Users
  mount Sessions
  mount Posts
  mount Categories
  mount Questions
end