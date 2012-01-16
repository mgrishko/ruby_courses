require 'spec_helper'

describe AccountDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @account = Fabricate(:account, country: "US", company_name: "My company", subdomain: "sub")
    @decorator = AccountDecorator.decorate(@account)
  end

  describe "allows" do
    it "#subdomain" do
      @decorator.subdomain.should == "sub"
    end

    it "#company_name" do
      @decorator.company_name.should == "My company"
    end
  end

  describe "decorates" do
    it "#country_name" do
      @decorator.country.should == "United States"
    end

    it "#state" do
      @decorator.state.should == "Awaiting activation"
    end

    describe "#activation_link" do
      context "when account is not activated" do
        it "should return link" do
          @decorator.activation_link.should == "<a href=\"/dashboard/accounts/#{@account.id}/activate\">Activate</a>"
        end
      end

      context "when account is already activated" do
        it "should be blank" do
          @account.activate
          decorator = AccountDecorator.decorate(@account)
          decorator.activation_link.should be_blank
        end
      end
    end

    describe "#login_as_owner_link" do
      context "when account is not activated" do
        it "should be blank" do
          @decorator.login_as_owner_link.should be_blank
        end
      end
      
      context "when account is already activated" do
        it "should return link" do
          @account.activate
          @decorator.login_as_owner_link.should == "<a href=\"/dashboard/accounts/#{@account.id}/login_as_owner\">Login as account owner</a>"
        end
      end
    end
  end
end
