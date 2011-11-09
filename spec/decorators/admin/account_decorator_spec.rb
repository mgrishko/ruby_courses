require 'spec_helper'

describe Admin::AccountDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @account = Fabricate(:account, country: "US")
    @decorator = Admin::AccountDecorator.decorate(@account)
  end

  it "shows country name" do
    @decorator.country.should == "United States"
  end

  it "shows state" do
    @decorator.state.should == "Awaiting activation"
  end

  it "generates activation link" do
    @decorator.activation_link.should == "<a href=\"/dashboard/accounts/#{@account.id}/activate\">Activate</a>"
  end
end
