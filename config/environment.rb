# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Webforms::Application.initialize!

Rails::Initializer.run do |config|
  config.gem :nokogiri
end
