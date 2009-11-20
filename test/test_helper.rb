ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require "authlogic/test_case"
require 'shoulda'
require 'factory_girl'

Factory.sequence :gtin do |n|
  gtin = (10 ** 12 + n).to_s
  three = false
  gtin + (10 - (gtin.split('').inject(0) { |sum, k| three = !three; sum + k.to_i * (three ? 3 : 1) } % 10)).to_s
end

Factory.define :article do |a|
  [:internal_item_id, :packaging_type, :gross_weight, :depth, :gpc, :content_uom, :country_of_origin, :height, :content, :minimum_durability_from_arrival, :vat, :width].each {|i| a.add_attribute i, 1}
  a.manufacturer_gln 1000000000000
  a.plu_description 'description'
  a.item_name_long_en 'simple name'
  a.item_name_long_ru 'simple name'
  a.manufacturer_name 'name'
  a.gtin { Factory.next(:gtin) }
end

Factory.define :packaging_item do |pi|
  [:gross_weight, :packaging_type, :number_of_next_lower_item, :depth, :number_of_bi_items, :height, :width].each {|i| pi.add_attribute i, 1}
  pi.gtin { Factory.next(:gtin) }
end

class ActiveSupport::TestCase
  include Authlogic::TestCase
  setup :asdf 
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def asdf
    if self.class.method_defined? :setup_controller_request_and_response
      setup_controller_request_and_response
    end
    activate_authlogic
  end

  def al_controller
    @al_controller ||= Authlogic::TestCase::MockController.new
  end
  # Add more helper methods to be used by all tests here...
  def authorize_user(user = users(:valid_user))
    bak = @controller
    @controller = UserSessionsController.new
    get :logout
    post :login, :user_session => { :gln => user.gln, :password => 'test' }
    @controller = bak
  end

  def authorize_admin
    authorize_user users(:admin)
  end

  def self.should_error_unauthorized
    should_redirect_to "login url" do 
      {:controller => :user_sessions, :action => :login}
    end
  end

  def self.should_not_error_unauthorized
    should_respond_with :success
  end

  def self.should_error_not_admin
    self.should_error_unauthorized
  end

  def self.should_not_error_not_admin
    should_respond_with :success
  end
end
