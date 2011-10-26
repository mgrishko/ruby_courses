require 'spork'

Spork.prefork do

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Mongoid likes to preload all of your models in rails, making Spork a near worthless experience.
  # It can be defeated with this code:
  require "rails/mongoid"
  Spork.trap_class_method(Rails::Mongoid, :load_models)

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # Rspec's use_transactional_fixtures option will have no affect on Mongoid,
    # so you can clean up your specs after the suite.
    require 'database_cleaner'

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = "mongoid"
    end

    config.before(:each) do
      DatabaseCleaner.clean
    end

    config.after(:each) do
      Timecop.return
    end

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = true
  end
end

Spork.each_run do
  # Require fabricators which are placed not in a standard place
  # It should be required on each run otherwise Spork caches classes.
  Dir[Rails.root.join("spec/fabricators/**/*.rb")].each {|f| require f}
end