require 'spec_helper'

describe "signup_accounts/index.html.haml" do
  before(:each) do
    assign(:signup_accounts, [
      stub_model(Signup::Account),
      stub_model(Signup::Account)
    ])
  end

  it "renders a list of signup_accounts" do
    render
  end
end
