source 'http://rubygems.org'
source 'http://gems.github.com'
source 'http://gemcutter.org'

gem 'rails', '3.0.10'
gem 'authlogic', '3.0.3'
gem 'aasm', :require => 'aasm'
gem 'responds_to_parent',:git => 'https://github.com/kennon/responds_to_parent.git'
gem 'will_paginate', '3.0.pre2'
gem 'haml'
gem 'dynamic_form'
gem 'jrails'
gem 'jquery-rails'
gem 'rmagick', :require => 'RMagick'
gem 'pg', :require => 'pg'
gem 'nested_set'
gem 'jrails'
gem 'jquery-rails'
gem 'rails3-jquery-autocomplete','0.7.5.1', :git => 'git://github.com/pavel-so/rails3-jquery-autocomplete.git'
gem 'xml2xls',:path => 'vendor/gems/xml2xls-0.2.5'
gem 'spreadsheet'
gem 'rubyzip'
gem 'ruby-xslt'
gem 'exception_notification', :git => 'https://github.com/rails/exception_notification.git', :require => 'exception_notifier'
gem 'russian', :git => "git://github.com/dima4p/russian.git"
gem 'cancan'
gem 'globalize3'
gem 'uservoice', :path => 'vendor/gems/uservoice'
gem 'wice_grid'

group :development, :test do
  if RUBY_PLATFORM =~ /win32/
    gem 'rb-fchange'
    gem 'rb-notifu'
  elsif RUBY_PLATFORM =~ /linux/
    gem 'rb-inotify'
    gem 'libnotify'
  elsif RUBY_PLATFORM =~ /darwin/
    gem 'rb-fsevent'
    gem 'growl'
  end

  gem 'annotate'
  gem 'capybara', '0.4.1.2'
  gem 'cucumber'
  gem 'cucumber-rails', '0.3.2', :require => false
  gem 'database_cleaner'
  gem 'email_spec',
      :git=>'git://github.com/bmabey/email-spec.git',
      :branch=>'rails3'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'headless'
  gem 'hpricot'
  gem 'pickle'
  gem 'rails-erd'
  gem 'rspec-rails', '~> 2.4'
  gem 'ruby_parser'
  gem 'selenium-webdriver', '2.5.0'
  gem 'spork'
  gem 'test-unit'
  gem 'thoughtbot-factory_girl', :require => false
end

group :development do
  gem 'translations_sync'
end

group :console do
  gem 'hirb'
  gem 'wirble'
end

