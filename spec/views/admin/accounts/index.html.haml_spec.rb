require 'spec_helper'

describe "admin/accounts/index.html.haml" do
  before(:each) do
    assign(:accounts, [
      stub_model(Account),
      stub_model(Account)
    ])
  end

  it "renders a list of accounts" do
    render
    rendered.should have_selector("table tr", count: 3)
  end

  it "renders a subdomain column" do
    render
    rendered.should have_selector("table th", text: "Subdomain")
  end

  it "renders a company column" do
    render
    rendered.should have_selector("table tr", text: "Company")
  end

  it "renders a country column" do
    render
    rendered.should have_selector("table tr", text: "Country")
  end

  it "renders a state column" do
    render
    rendered.should have_selector("table tr", text: "State")
  end
end
