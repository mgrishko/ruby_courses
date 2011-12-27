require 'spec_helper'

describe Admin::AccountDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @account = Fabricate(:account, country: "US", company_name: "My company", subdomain: "sub")
    @decorator = Admin::AccountDecorator.decorate(@account)
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

    it "#activation_link" do
      @decorator.activation_link.should == "<a href=\"/dashboard/accounts/#{@account.id}/activate\">Activate</a>"
    end
    
    it "#login_as_owner_link" do
      @decorator.login_as_owner_link.should == "<a href=\"/dashboard/accounts/#{@account.id}/login_as_owner\">Login as account owner</a>"
    end
  end
end
