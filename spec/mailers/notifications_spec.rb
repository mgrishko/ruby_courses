require "spec_helper"
require 'rspec/mocks/spec_methods'

describe Notification do
  include RSpec::Mocks::ExampleMethods
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  before (:each) do
    mock_user({
      :name => 'New user',
      :email => "users@email.info",
      :perishable_token => 'pcode'
    })
    I18n.locale = :en
  end

  describe 'accept_invitation_request_email' do
    before (:each) do
      ActionMailer::Base.default_url_options = {:host => 'datapool.ru'}
      @email = Notification.accept_invitation_request_email mock_user
    end

    subject { @email }

    it "should be delivered to the user's email" do
      should deliver_to("users@email.info")
    end

    it "should have bcc" do
      should bcc_to("mrostotski@gmail.com")
    end

    it "should be delivered from server.ror.account@gmail.com" do
      should deliver_from("server.ror.account@gmail.com")
    end

    it { should have_subject("Welcome to Getmasterdata.") }

    it "should have link to the main page" do
      should have_body_text("http://datapool.ru/")
    end

  end

  describe 'decline_invitation_request_email' do
    before (:each) do
      ActionMailer::Base.default_url_options = {:host => 'datapool.ru'}
      @email = Notification.decline_invitation_request_email mock_user
    end

    subject { @email }

    it "should be delivered to the user's email" do
      should deliver_to("users@email.info")
    end

    it "should have bcc" do
      should bcc_to("mrostotski@gmail.com")
    end

    it "should be delivered from server.ror.account@gmail.com" do
      should deliver_from("server.ror.account@gmail.com")
    end

    it { should have_subject("Sorry, your invitation request was declined.") }

    it do
      should have_body_text("Sorry, but your request was declined.")
    end

  end

  describe 'password_reset_instructions' do
    before (:each) do
      ActionMailer::Base.default_url_options = {:host => 'datapool.ru'}
      @email = Notification.password_reset_instructions mock_user
    end

    subject { @email }

    it "should be delivered to the user's email" do
      should deliver_to("users@email.info")
    end

    it "should not have bcc" do
      should_not bcc_to("mrostotski@gmail.com")
    end

    it "should be delivered from server.ror.account@gmail.com" do
      should deliver_from("server.ror.account@gmail.com")
    end

    it { should have_subject("Getmasterdata: Password Reset Instructions") }

    it "should have link to update the password" do
      should have_body_text("http://datapool.ru/password_resets/pcode/edit")
    end

  end

end
