GoodsMaster::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # I18n-js support
  config.assets.initialize_on_precompile = true

  # Setting default_url_options (required for devise).
  config.action_mailer.default_url_options = { :host => 'example.com' }

  # Rescues Exceptions
  config.action_dispatch.rescue_responses.merge!(
    'BSON::InvalidObjectId'   => :not_found
  )

  # Monkey patching bootstap assets (they does not included by default)
  gems_path = ENV['GEM_PATH'].split(":").first
  bootstrap_assets_path  = Dir["#{gems_path}/gems/bootstrap-sass-*/vendor/assets"].last
  config.assets.paths << "#{bootstrap_assets_path}/javascripts"
  config.assets.paths << "#{bootstrap_assets_path}/stylesheets"
end
