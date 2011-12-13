source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem "rake", "~> 0.9.2.2"

# ORM and relative
gem "mongoid", "~> 2.3.2"
gem "bson_ext"
gem "mongoid_i18n", "~> 0.5.1"
gem "mongoid_session_store", "~> 2.0.1"
gem "state_machine"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'bootstrap-sass', '1.4.0'
  #gem 'compass', "~> 0.11.5"

  gem 'execjs'
  gem 'therubyracer', :platforms => :mri   # Skip in jRuby evnironment
  gem 'therubyrhino', :platforms => :jruby # Build in jruby environment
end

# This assets gems should be global wide accessible to respond to js, for ex. with create.js.coffee:
gem 'coffee-rails', '~> 3.1.1'
gem 'uglifier', '>= 1.0.3'

# Security related gems
gem "devise", "~> 1.4.9"
gem "cancan", "~> 1.6.7"

# Frontend tools
gem 'jquery-rails'
gem "remotipart", "~> 1.0.1" # for AJAX file uploads
gem 'haml'
gem "simple_form", git: "git://github.com/plataformatec/simple_form.git"
gem "carmen" # country_select and state_select plugin
gem "simple-navigation", "~> 3.5.0"

# Backend tools
gem "responders"
gem "draper"
gem "settingslogic", "~> 2.0.6"
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mini_magick'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-ext'

# External services
gem "airbrake"
gem "newrelic_rpm"

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# Next gems also in development to run generators and rake tasks
group :development, :test, :cucumber do
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'fabrication', "~> 1.2.0"
  gem "spork", '0.9.0.rc9'
  gem "email_spec", "~> 1.2.1"
end

group :test, :cucumber do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'capybara', "~> 1.1.1"
  gem "capybara-webkit"
  gem "headless"
  gem 'database_cleaner'
  gem 'ffaker'
  gem "shoulda-matchers"
  gem 'timecop'
  gem 'launchy'
  gem 'simplecov', :require => false
end

# Gems used only in development and not required
# in production environments by default.
group :development do
  gem 'haml-rails'
  gem 'hpricot'
  gem 'ruby_parser'
end
