# Be sure to restart your server when you modify this file.

#GoodsMaster::Application.config.session_store :cookie_store, key: '_gm_session'
GoodsMaster::Application.config.session_store :mongoid_store, domain: :all

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# GoodsMaster::Application.config.session_store :active_record_store


# This is a monkey patch due to issue with :domain => :all option
# https://github.com/rails/rails/issues/3047
class ActionDispatch::Session::AbstractStore
  def call(env)
    # the only place I could find that knows how to mutate out the `:all` was the CookieJar, so we use that before Rack gets an invalid :domain
    ActionDispatch::Request.new(env).cookie_jar.handle_options(@default_options)
    super
  end
end

