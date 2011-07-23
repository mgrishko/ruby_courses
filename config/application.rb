require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Webforms
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]
  end

TMP_DIR = File.join(::Rails.root.to_s, 'tmp')
RECORDS_IN_DIR = File.join(TMP_DIR, 'records_in_dir')
RECORDS_OUT_DIR = File.join(TMP_DIR, 'records_out_dir')

FileUtils.mkdir_p(RECORDS_IN_DIR)
FileUtils.mkdir_p(RECORDS_OUT_DIR)

  APP_CONFIG = { } unless defined?(APP_CONFIG)
APP_CONFIG[:mail] = {
	:server => {
		:email => "server.ror.account@gmail.com",
		:password  => '12381238',
		:smtp_address => "smtp.gmail.com",
		:smtp_port => '587',
		:pop_address => 'pop.gmail.com',
		:pop_port => 995,
		:domain => "localhost",
		:smtp_authentication => :plain,
	},
	:client => {
        :imap_port => 993,
        :imap_address => 'imap.gmail.com',
		:email => "client.ror.account@gmail.com",
		:password  => '12381238',
		:smtp_address => "smtp.gmail.com",
		:pop_address => 'pop.gmail.com',
		:pop_port => 995,
		:domain => "localhost",
		:smtp_port => '587',
		:smtp_authentication => :plain,
	}
}

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
	:address => APP_CONFIG[:mail][:client][:smtp_address],
	:port => APP_CONFIG[:mail][:client][:smtp_port],
	:domain => APP_CONFIG[:mail][:client][:domain],
	:authentication => APP_CONFIG[:mail][:client][:smtp_authentication],
	:user_name => APP_CONFIG[:mail][:client][:email],
	:password => APP_CONFIG[:mail][:client][:password]
}
  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  error_class = "error_field"
  if html_tag =~ /<(input|textarea|select)[^>]+class=/
    puts(html_tag)
    class_attribute = html_tag =~ /class=['"]/
    html_tag.insert(class_attribute + 7, "#{error_class} ")
  elsif html_tag =~ /<(input|textarea|select)/
    first_whitespace = html_tag =~ /\s/
    html_tag[first_whitespace] = " class='#{error_class}' "
  end
  html_tag
end
  Time::DATE_FORMATS.merge!({:short => "%Y-%m-%d", :cmnt => "%a, %d %b %Y, %H:%M", :db => "%Y-%m-%d %H:%M", :event => "%d %b %Y, %A"})
IMAGE_PARAMETERS = [
  {
    'name'    => 'big', # big
    'width'   => 800,
    'height'  => 600,
    'scale'   => false,
    'fill'    => false
  }, {
    'name'    => '', # without suffix = medium
    'width'   => 200,
    'height'  => 200,
    'scale'   => false,
    'fill'    => false
  }, {
    'name'    => 'small', # small
    'width'   => 50,
    'height'  => 50,
    'scale'   => true,
    'fill'    => true
  }, {
    'name'    => 'tile', # small
    'width'   => 163,
    'height'  => 163,
    'scale'   => false,
    'fill'    => false
  }
]
end

RTL_LANGS = [:ar, :dv, :fa, :ha, :he, :ps, :ur, :yi]

