require File.join(File.expand_path(File.dirname(__FILE__)), 'boot.rb')

map '/api' do
  run NiftyServicesSamples::SinatraApp
end