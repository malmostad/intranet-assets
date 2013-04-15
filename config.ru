# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# Required for serving web fonts to another server
use Rack::ResponseHeaders do |headers|
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'Content-type'
end

run AssetsContainer::Application
