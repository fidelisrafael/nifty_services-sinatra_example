require 'bundler'
Bundler.require

require 'sinatra/base'
require 'sinatra/namespace'
require "sinatra/json"
require 'nifty_services'

require 'i18n'
require 'i18n/backend/fallbacks'

require 'letter_opener'

Dir['app/{**, **/**}/*.rb'].sort.each {|file| require File.expand_path(file) }

NiftyServices.config do |config|
  config.user_class = User
  File.new('log/app_services.log', 'w')
  file = File.open('log/app_services.log', File::WRONLY | File::APPEND)
  config.logger = Logger.new(file)
end

Pony.override_options = { :to => 'admin@myapp.com' }

Pony.options = {
  :via => LetterOpener::DeliveryMethod,
  :via_options => { :location => File.expand_path('tmp/letter_opener') }
}

NiftyServices::BaseCrudService.class_eval do
  def validate_api_key?
    option_enabled?(:validate_api_key)
  end

  def valid_api_key?
    @options[:api_key] && @options[:api_key] == universal_api_key
  end

  def universal_api_key
    Digest::MD5.hexdigest('work it harder, make it better, do it faster, make us stronger!')
  end
end

require './app'
